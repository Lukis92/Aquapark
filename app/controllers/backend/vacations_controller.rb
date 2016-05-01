class Backend::VacationsController < BackendController
  before_action :set_vacation, only: [:edit, :update, :destroy]
  before_action :set_person, only: [:list]
  before_action :set_employees, only: [:new, :create]
  helper_method :sort_column, :sort_direction
  # GET backend/vacations
  # GET backend/vacations.json
  def index
    respond_to do |format|
      format.html { @vacations = Vacation.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 20) }
      format.json { @vacations = Vacation.all }
    end
  end

  # GET backend/vacations/new
  def new
    @vacation = Vacation.new
  end

  # POST backend/vacations
  # POST backend/vacations.json
  def create
    @vacation = Vacation.new(vacation_params)
    respond_to do |format|
      if @vacation.save
        format.html { redirect_to backend_vacations_path, notice: 'Pomyślnie dodano.' }
        format.json { render :show, status: :created, location: @vacation }
      else
        format.html { render :new }
        format.json { render json: @vacation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT backend/vacations/1
  # PATCH/PUT backend/vacations/1.json
  def update
    respond_to do |format|
      if @vacation.update(vacation_params)
        format.html { redirect_to backend_vacations_path, notice: 'Pomyślnie zaktualizowano.' }
        format.json { render :show, status: :ok, location: @vacation }
      else
        format.html { render :edit }
        format.json { render json: @vacation.errors, status: :unprocessable_entity }
        end
    end
  end

  # DELETE backend/vacations/1
  # DELETE backend/vacations/1.json
  def destroy
    @vacation.destroy
    respond_to do |format|
      format.html { redirect_to backend_vacations_path, notice: 'Pomyślnie usunięto.' }
      format.json { head :no_content }
    end
  end

  def list
    @old_vacations = Vacation.where(person_id: @person.id).where(['end_at < ?', Date.today]).paginate(page: params[:page], per_page: 20)
    @current_vacation = Vacation.where(person_id: @person.id).where(['start_at < ?', Date.today]).where(['end_at > ?', Date.today]).first
    @all_vacations = Vacation.all
    @nearest_vacations = Vacation.where(person_id: @person.id).where(['start_at > ?', Date.today]).order(:start_at).paginate(page: params[:page], per_page: 20)
    @nearest_vacation = @nearest_vacations.first
    @days = 0
    @vac_days = (@current_vacation.end_at - @current_vacation.start_at).to_i unless @current_vacation.blank?
    @days = (@nearest_vacation.start_at - Date.today).to_i unless @nearest_vacation.blank?
  end

  private

  def vacation_params
    params.require(:vacation).permit(:start_at, :end_at, :free, :reason, :person_id)
  end

  def sort_column
    Vacation.column_names.include?(params[:sort]) ? params[:sort] : 'start_at'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def set_vacation
    @vacation = Vacation.find(params[:id])
  end

  def set_person
    @person = Person.find(params[:id])
  end

  def set_employees
    @employees = Person.all.where.not(type: 'Client')
  end
end
