class Backend::WorkSchedulesController < BackendController
  before_action :set_work_schedule, only: [:edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :set_person, only: [:show]
  before_action :manager_person, only: [:edit, :destroy]
  before_action :select_rule_work_schedules, only: [:index, :new]
  before_action :manage_rule_work_schedules, only: [:edit, :update, :destroy]
  before_action :show_rule_work_schedules, only: :show
  before_action :set_employees
  # GET backend/work_schedules
  def index
    if @person.blank?
      case params[:day_of_week]
      when 'monday'
        @work_schedules = WorkSchedule.where(day_of_week: 'Poniedziałek')
                                      .order(sort_column + ' ' + sort_direction)
                                      .paginate(page: params[:page], per_page: 20)
      when 'tuesday'
        @work_schedules = WorkSchedule.where(day_of_week: 'Wtorek')
                                      .order(sort_column + ' ' + sort_direction)
                                      .paginate(page: params[:page], per_page: 20)
      when 'wednesday'
        @work_schedules = WorkSchedule.where(day_of_week: 'Środa')
                                      .order(sort_column + ' ' + sort_direction)
                                      .paginate(page: params[:page], per_page: 20)
      when 'thursday'
        @work_schedules = WorkSchedule.where(day_of_week: 'Czwartek')
                                      .order(sort_column + ' ' + sort_direction)
                                      .paginate(page: params[:page], per_page: 20)
      when 'friday'
        @work_schedules = WorkSchedule.where(day_of_week: 'Piątek')
                                      .order(sort_column + ' ' + sort_direction)
                                      .paginate(page: params[:page], per_page: 20)
      when 'saturday'
        @work_schedules = WorkSchedule.where(day_of_week: 'Sobota')
                                      .order(sort_column + ' ' + sort_direction)
                                      .paginate(page: params[:page], per_page: 20)
      when 'sunday'
        @work_schedules = WorkSchedule.where(day_of_week: 'Niedziela')
                                      .order(sort_column + ' ' + sort_direction)
                                      .paginate(page: params[:page], per_page: 20)
      else
        @work_schedules = WorkSchedule.order("CASE day_of_week
                WHEN 'Poniedziałek' THEN 1 WHEN 'Wtorek' THEN 2 WHEN 'Środa'
                THEN 3 WHEN 'Czwartek' THEN 4 WHEN 'Piątek' THEN 5
                WHEN 'Sobota' THEN 6
                WHEN 'Niedziela' THEN 7 END")
                                      .order(sort_column + ' ' + sort_direction)
                                      .paginate(page: params[:page], per_page: 20)
      end

    else
      @work_schedules = WorkSchedule.where(person_id: @person.id).order("CASE day_of_week
              WHEN 'Poniedziałek' THEN 1 WHEN 'Wtorek' THEN 2 WHEN 'Środa'
              THEN 3 WHEN 'Czwartek' THEN 4 WHEN 'Piątek' THEN 5
              WHEN 'Sobota' THEN 6
              WHEN 'Niedziela' THEN 7 END")
                                    .order(sort_column + ' ' + sort_direction)
                                    .paginate(page: params[:page],
                                              per_page: 20)
    end
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
      redirect_to backend_work_schedules_path,
                  notice: 'Pomyślnie zaktualizowano.'
    else
      render :edit
    end
  end

  # DELETE backend/work_schedules/1
  def destroy
    @work_schedule.destroy
    redirect_to :back, notice: 'Pomyślnie usunięto.'
  end

  def show
    @nearest_vacation = Vacation.where(person_id: @person.id)
                                .where(['start_at > ?', Date.today]).first
    @p_work_schedules = @person.work_schedules.order("CASE day_of_week
            WHEN 'Poniedziałek' THEN 1 WHEN 'Wtorek' THEN 2 WHEN 'Środa'
            THEN 3 WHEN 'Czwartek' THEN 4 WHEN 'Piątek' THEN 5
            WHEN 'Sobota' THEN 6
            WHEN 'Niedziela' THEN 7 END")
  end

  # GET backend/work_schedules/search
  def search
    if params[:query].present?
      @work_schedules = WorkSchedule.text_search(params[:query])
                                    .paginate(page: params[:page],
                                              per_page: 20)
    else
      @work_schedules = WorkSchedule.paginate(page: params[:page],
                                              per_page: 20)
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
    if WorkSchedule.column_names.include?(params[:sort])
      params[:sort]
    else
      'day_of_week'
    end
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

  # Ability to edit and destroy work schedules
  def manager_person
    unless current_manager
      flash[:danger] = "Brak dostępu.{manager_person}"
      redirect_to backend_root_path
    end
  end

  # Ability to select schedules
  def select_rule_work_schedules
    unless current_manager
      flash[:danger] = "Brak dostępu. {set_rule_to_display_work_schedules}"
      redirect_to backend_root_path
    end
  end

  def show_rule_work_schedules
    unless current_manager || current_person == @person
      flash[:danger] = "Brak dostępu. {show_rule_work_schedules}"
      redirect_to backend_root_path
    end
  end

  def manage_rule_work_schedules
    unless current_manager
      flash[:danger] = "Brak dostępu. {manage_rule_work_schedules}"
      redirect_to backend_root_path
    end
  end
end
