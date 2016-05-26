class Backend::WorkSchedulesController < BackendController
  before_action :set_work_schedule, only: [:edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :set_person, only: [:show]
  before_action :manager_person, only: [:edit, :destroy]
  before_action :set_rule_to_display_work_schedules, only: [:index, :show]
  before_action :set_employees

  # GET backend/work_schedules
  def index
    @work_schedules = WorkSchedule.order("CASE day_of_week
            WHEN 'Poniedziałek' THEN 1 WHEN 'Wtorek' THEN 2 WHEN 'Środa'
            THEN 3 WHEN 'Czwartek' THEN 4 WHEN 'Piątek' THEN 5
            WHEN 'Sobota' THEN 6
            WHEN 'Niedziela' THEN 7 END")
                                  .order(sort_column + ' ' + sort_direction)
                                  .paginate(page: params[:page],
                                            per_page: 20)
  end

  # GET backend/work_schedules/new
  def new
    @work_schedule = WorkSchedule.new
  end

  # POST backend/work_schedules
  def create
    @work_schedule = WorkSchedule.new(work_schedule_params)
    if @work_schedule.save
      redirect_to backend_work_schedules_path, notice: 'Pomyślnie dodano.'
    else
      render :new
    end
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
  end

  # GET backend/work_schedules/search
  def search
    if params[:query].present?
      @work_schedules = WorkSchedule.text_search(params[:query])
                                    .paginate(page: params[:page],
                                              per_page: 20)
    end
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
