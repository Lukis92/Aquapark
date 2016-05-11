class Backend::VacationsController < BackendController
  before_action :set_vacation, only: [:edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :set_person, only: [:new, :create, :list]
  before_action :set_employees

  # GET backend/vacations
  # GET backend/vacations.json
  def index
    respond_to do |format|
      format.html do
        @vacations = Vacation.order(sort_column + ' ' + sort_direction)
                             .paginate(page: params[:page], per_page: 20)
      end
      format.json { @vacations = Vacation.all }
    end
  end

  # GET backend/vacations/new
  def new
    @vacation = Vacation.new
    @@person_id = @person.id unless @person.blank?
  end

  # POST backend/vacations
  # POST backend/vacations.json
  def create
    @vacation = Vacation.new(vacation_params)
    @vacation.person_id = @@person_id unless @@person_id == 0
    respond_to do |format|
      if @vacation.save
        format.html do
          redirect_to backend_vacations_path,
                      notice: 'Pomyślnie dodano.'
        end
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT backend/vacations/1
  # PATCH/PUT backend/vacations/1.json
  def update
    respond_to do |format|
      if @vacation.update(vacation_params)
        format.html do
          redirect_to backend_vacations_path,
                      notice: 'Pomyślnie zaktualizowano.'
        end
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE backend/vacations/1
  # DELETE backend/vacations/1.json
  def destroy
    @vacation.destroy
    respond_to do |format|
      format.html do
        redirect_to backend_vacations_path,
                    notice: 'Pomyślnie usunięto.'
      end
    end
  end

  def list
    @old_vacations = Vacation.where(person_id: @person.id)
                             .where(['end_at < ?', Date.today])
                             .paginate(page: params[:page], per_page: 20)
    @current_vacation = Vacation.where(person_id: @person.id)
                                .where(['start_at <= ?', Date.today])
                                .where(['end_at >= ?', Date.today]).first
    @all_vacations = Vacation.all
    @nearest_vacations = Vacation.where(person_id: @person.id)
                                 .where(['start_at > ?', Date.today])
                                 .order(:start_at)
                                 .paginate(page: params[:page], per_page: 20)
    @nearest_vacation = @nearest_vacations.first
    @days = 0
    # count days to end of current vacation
    unless @current_vacation.blank?
      @end_vacation = (@current_vacation.end_at - Date.today).to_i
    end

    unless @current_vacation.blank?
      @vac_days = (@current_vacation.end_at - @current_vacation.start_at).to_i
    end

    unless @nearest_vacation.blank?
      @days = (@nearest_vacation.start_at - Date.today).to_i
    end
  end

  private

  def vacation_params
    params.require(:vacation)
          .permit(:start_at, :end_at, :free, :reason, :person_id)
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
    @person = Person.find(params[:id]) unless params[:id].blank?
  end

  def set_employees
    @employees = Person.where.not(type: 'Client')
  end
end
