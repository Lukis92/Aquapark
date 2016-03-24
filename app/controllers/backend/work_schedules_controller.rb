class Backend::WorkSchedulesController < BackendController
    before_action :set_work_schedule, only: [:edit, :update, :destroy]
    before_action :select_employee, only: [:new, :edit]
    helper_method :sort_column, :sort_direction
    before_action :set_person, only: [:show]
    before_action :set_employees, only: [:create, :edit, :update]
    before_action :set_current_person

  # GET backend/work_schedules
  # GET backend/work_schedules.json
  def index
    respond_to do |format|
      format.html { @work_schedules = WorkSchedule.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 5) }
      format.json { @work_schedules = WorkSchedule.all }
    end
  end

  # GET backend/work_schedules/new
  def new
    @work_schedule = WorkSchedule.new
  end

  # POST backend/work_schedules
  # POST backend/work_schedules.json
  def create
    @work_schedule = WorkSchedule.new(work_schedule_params)
    respond_to do |format|
      if @work_schedule.save
       format.html { redirect_to backend_work_schedules_path, notice: 'Pomyślnie dodano.' }
       format.json { render :show, status: :created, location: @work_schedule }
      else
       format.html { render :new }
       format.json { render json: @work_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT backend/work_schedules/1
  # PATCH/PUT backend/work_schedules/1.json
  def update
    respond_to do |format|
      if @work_schedule.update(work_schedule_params)
        format.html { redirect_to backend_work_schedules_path, notice: 'Pomyślnie zaktualizowano.' }
        format.json { render :show, status: :ok, location: @work_schedule }
      else
        format.html { render :edit }
        format.json { render json: @work_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE backend/work_schedules/1
  # DELETE backend/work_schedules/1.json
  def destroy
    @work_schedule.destroy
    respond_to do |format|
      format.html { redirect_to backend_work_schedules_path, notice: 'Pomyślnie usunięto.'}
      format.json { head :no_content }
    end
  end

  def show
    #code
  end

  private

    def work_schedule_params
      params.require(:work_schedule).permit(:start_time, :end_time, :day_of_week, :person_id)
    end
    def set_work_schedule
      @work_schedule = WorkSchedule.find(params[:id])
    end
    def set_person
      @person = Person.find(params[:id])
    end
    def set_employees
      @employees = Person.where.not(type: "Client")
    end
    def set_current_person
      @current_person = current_person
    end

    def select_employee
      @employee = Person.where.not(type: "Client")
    end

    def sort_column
      WorkSchedule.column_names.include?(params[:sort]) ? params[:sort] : "day_of_week"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
