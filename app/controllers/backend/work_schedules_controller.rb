class Backend::WorkSchedulesController < BackendController
  before_action :set_work_schedule, only: [:edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :set_person, only: [:show]
  before_action :manager_person, only: [:edit, :destroy]
  before_action :set_rule_to_display_work_schedules, only: [:index, :show]
  before_action :set_employees

  @@person_id = 0

  # GET backend/work_schedules
  def index
    respond_to do |format|
      format.html do
        @work_schedules = WorkSchedule.order("CASE day_of_week
                WHEN 'Poniedziałek' THEN 1 WHEN 'Wtorek' THEN 2 WHEN 'Środa'
                THEN 3 WHEN 'Czwartek' THEN 4 WHEN 'Piątek' THEN 5
                WHEN 'Sobota' THEN 6
                WHEN 'Niedziela' THEN 7 END")
                                      .order(sort_column + ' ' + sort_direction)
                                      .paginate(page: params[:page],
                                                per_page: 20)
      end
    end
  end

  # GET backend/work_schedules/new
  def new
    @work_schedule = WorkSchedule.new
    @@person_id = @person.id unless @person.blank?
  end

  # POST backend/work_schedules
  def create
    @work_schedule = WorkSchedule.new(work_schedule_params)
    @work_schedule.person_id = @@person_id unless @@person_id == 0 &&
                                                  @work_schedule.person_id
                                                                .present?
    respond_to do |format|
      if @work_schedule.save
        format.html do
          redirect_to backend_work_schedules_path,
                      notice: 'Pomyślnie dodano.'
        end
        format.json { render :show, status: :created, location: @work_schedule }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT backend/work_schedules/1
  def update
    respond_to do |format|
      if @work_schedule.update(work_schedule_params)
        format.html do
          redirect_to backend_work_schedules_path,
                      notice: 'Pomyślnie zaktualizowano.'
        end
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE backend/work_schedules/1
  def destroy
    @work_schedule.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Pomyślnie usunięto.' }
    end
  end

  def show
    # @vacation = Vacation.all.where(person_id: @person.id).first unless
    @nearest_vacation = Vacation.where(person_id: @person.id)
                                .where(['start_at > ?', Date.today]).first
  end

  private

  def work_schedule_params
    params.require(:work_schedule)
          .permit(:start_time, :end_time, :day_of_week, :person_id)
  end

  def set_work_schedule
    @work_schedule = WorkSchedule.find(params[:id])
  end

  def set_person
    @person = Person.find(params[:id])
  end

  def set_employees
    @employees = Person.where.not(type: 'Client')
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
    unless current_person.type == 'Manager'
      flash[:danger] = "Nie masz uprawnień do tej sekcji."
      redirect_to backend_root_path
    end
  end

  # Ability to select schedules
  def set_rule_to_display_work_schedules
    unless current_person.type == 'Manager' || current_person.type == 'Receptionist'
      flash[:danger] = "Nie masz uprawnień do tej sekcji."
      redirect_to backend_root_path
    end
  end
end
