class Backend::WorkSchedulesController < BackendController
  before_action :set_work_schedule, only: [:edit, :update, :destroy]
  include Sortable
  helper_method :sort_column
  before_action :set_person, only: [:show]
  before_action :manager_person, only: [:edit, :destroy]
  before_action :select_rule_work_schedules, only: [:index, :new]
  before_action :manage_rule_work_schedules, only: [:edit, :update, :destroy, :bulk_create]
  before_action :show_rule_work_schedules, only: :show
  before_action :set_employees
  # GET backend/work_schedules
  def index
    people_scope = Person.where.not(type: 'Client').order(:first_name, :last_name)

    if params[:person_id].present?
      @selected_person = Person.find_by(id: params[:person_id])
      people_scope = people_scope.where(id: @selected_person.id) if @selected_person
    end

    if params[:person_type].present?
      people_scope = people_scope.where(type: params[:person_type])
    end

    people_scope = people_scope.joins(:work_schedules).distinct

    @people = people_scope.paginate(page: params[:page], per_page: 20)

    schedules_by_pid = WorkSchedule.where(person_id: @people.map(&:id))
                                   .group_by(&:person_id)

    @schedule_data = @people.map { |p| [p, schedules_by_pid.fetch(p.id, [])] }.to_h
  end

  def new
    @work_schedule = WorkSchedule.new
  end

  # POST backend/work_schedules
  def create
    @work_schedule = if params.key?(:work_schedule)
                       WorkSchedule.new(work_schedule_params)
                     else
                       WorkSchedule.new(manage_schedule_params)
                     end
    if @work_schedule.save
      Notification.notify(
        person:     @work_schedule.person,
        actor:      current_person,
        kind:       'work_schedule_added',
        message:    "Dodano grafik pracy: #{@work_schedule.day_of_week} #{l(@work_schedule.start_time, format: :short)}–#{l(@work_schedule.end_time, format: :short)}.",
        notifiable: @work_schedule
      ) if @work_schedule.person != current_person
      redirect_to backend_work_schedules_path, notice: 'Pomyślnie dodano.'
    else
      render :new
    end
  end

  # GET backend/people/:id/work_schedules/:id
  def edit
  end

  # PATCH/PUT backend/work_schedules/1
  def update
    if @work_schedule.update(work_schedule_params)
      Notification.notify(
        person:     @work_schedule.person,
        actor:      current_person,
        kind:       'work_schedule_updated',
        message:    "Zmieniono grafik pracy: #{@work_schedule.day_of_week} #{l(@work_schedule.start_time, format: :short)}–#{l(@work_schedule.end_time, format: :short)}.",
        notifiable: @work_schedule
      ) if @work_schedule.person != current_person
      redirect_to backend_work_schedules_path, notice: 'Pomyślnie zaktualizowano.'
    else
      render :edit
    end
  end

  # DELETE backend/work_schedules/1
  def destroy
    person  = @work_schedule.person
    day     = @work_schedule.day_of_week
    t_start = l(@work_schedule.start_time, format: :short)
    t_end   = l(@work_schedule.end_time,   format: :short)
    @work_schedule.destroy
    Notification.notify(
      person:  person,
      actor:   current_person,
      kind:    'work_schedule_removed',
      message: "Usunięto grafik pracy: #{day} #{t_start}–#{t_end}."
    ) if person != current_person
    safe_redirect_back notice: 'Pomyślnie usunięto.'
  end

  def show
    @nearest_vacation = Vacation.where(person_id: @person.id)
                                .where(['start_at > ?', Date.today]).first
    @p_work_schedules = @person.work_schedules.order(Arel.sql("CASE day_of_week
            WHEN 'Poniedziałek' THEN 1 WHEN 'Wtorek' THEN 2 WHEN 'Środa'
            THEN 3 WHEN 'Czwartek' THEN 4 WHEN 'Piątek' THEN 5
            WHEN 'Sobota' THEN 6
            WHEN 'Niedziela' THEN 7 END"))
  end

  # POST backend/work_schedules/bulk_create
  def bulk_create
    days       = Array(params[:days]).reject(&:blank?)
    person_ids = Array(params[:person_ids]).reject(&:blank?)
    start_time = params[:start_time]
    end_time   = params[:end_time]

    if days.empty? || person_ids.empty? || start_time.blank? || end_time.blank?
      @work_schedule = WorkSchedule.new
      flash.now[:danger] = 'Wybierz co najmniej jeden dzień, jednego pracownika oraz godziny.'
      return render :new
    end

    created = 0
    skipped = 0
    errors  = []

    person_ids.each do |pid|
      days.each do |day|
        ws = WorkSchedule.new(start_time: start_time, end_time: end_time,
                              day_of_week: day, person_id: pid)
        if ws.save
          created += 1
        elsif ws.errors[:day_of_week].any?
          skipped += 1
        else
          person_name = Person.find_by(id: pid)&.full_name || "id=#{pid}"
          errors << "#{person_name} / #{day}: #{ws.errors.full_messages.join(', ')}"
        end
      end
    end

    if errors.empty?
      msg = "Dodano #{created} grafiów pracy."
      msg += " Pominięto #{skipped} (już istniały)." if skipped > 0
      redirect_to backend_work_schedules_path, notice: msg
    else
      @work_schedule = WorkSchedule.new
      flash.now[:danger] = "Dodano #{created}, pominięto #{skipped}. Błędy: #{errors.join(' | ')}"
      render :new
    end
  end

  # GET backend/work_schedules/search
  def search
    if params[:query].present?
      @work_schedules = WorkSchedule.includes(:person)
                                    .text_search(params[:query])
                                    .paginate(page: params[:page],
                                              per_page: 20)
                                    .references(:people)
    else
      @work_schedules = WorkSchedule.includes(:person)
                                    .paginate(page: params[:page],
                                              per_page: 20)
                                    .references(:people)
    end
  end

  private

  def work_schedule_params
    params.require(:work_schedule)
          .permit(:start_time, :end_time, :day_of_week, :person_id, :created_at, :updated_at)
  end

  def manage_schedule_params
    params.require(:manage_schedule)
          .permit(:start_time, :end_time, :day_of_week, :person_id, :created_at, :updated_at)
  end

  def set_work_schedule
    @work_schedule = WorkSchedule.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie ma harmonogramu pracy o takim id.'
    redirect_to backend_news_index_path
  end

  def set_person
    @person = Person.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie ma osoby o takim id.'
    redirect_to backend_news_index_path
  end

  def set_employees
    @employees = Person.where.not(type: 'Client').order(:first_name, :last_name)
  end

  def set_current_person
    @current_person = current_person
  end

  def sort_column
    sortable_column(WorkSchedule, default: 'day_of_week', joined: %w(people.first_name))
  end

  # Ability to edit and destroy work schedules
  def manager_person
    unless current_manager
      flash[:danger] = 'Brak dostępu.{manager_person}'
      redirect_to backend_root_path
    end
  end

  # Ability to select schedules
  def select_rule_work_schedules
    unless current_manager
      flash[:danger] = 'Brak dostępu. {set_rule_to_display_work_schedules}'
      redirect_to backend_root_path
    end
  end

  def show_rule_work_schedules
    unless current_manager || current_person == @person
      flash[:danger] = 'Brak dostępu. {show_rule_work_schedules}'
      redirect_to backend_root_path
    end
  end

  def manage_rule_work_schedules
    unless current_manager
      flash[:danger] = 'Brak dostępu. {manage_rule_work_schedules}'
      redirect_to backend_root_path
    end
  end
end
