class Backend::ManageTrainingsController < BackendController
  before_action :set_manage_training, only: [:edit, :update, :destroy]
  before_action :set_clients
  before_action :set_trainers
  before_action :set_training_cost
  def index
    @manage_trainings = IndividualTraining.paginate(page: params[:page],
                                                    per_page: 20)
  end

  # GET backend/individual_trainings/new
  def new
    @manage_training = IndividualTraining.new
  end

  # POST backend/individual_trainings
  def create
    @manage_training = IndividualTraining.new(manage_training_params)
    if @manage_training.save
      redirect_to :back, notice: 'Pomyślnie dodano.'
    else
      render :new
    end
  end

  # PATCH/PUT backend/individual_trainings/1
  def update
    if @manage_training.update(manage_training_params)
      redirect_to :back, notice: 'Pomyślnie zaktualizowano.'
    else
      render :edit
    end
  end

  # DELETE backend/individual_trainings/1
  def destroy
    @manage_training.destroy
    redirect_to :back, notice: 'Pomyślnie usunięto.'
  end

  private

  def manage_training_params
    params.require(:manage_training)
          .permit(:cost, :date_of_training, :start_on, :end_on, :client_id,
                  :trainer_id, :training_cost_id, :duration, :day)
  end

  def set_clients
    @clients = Person.where(type: 'Client')
  end

  def set_trainers
    @trainers = Person.where(type: 'Trainer')
  end

  def set_manage_training
    begin
      @manage_training = IndividualTraining.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      flash[:danger] = 'Nie istnieje trening o takim id.'
      redirect_to backend_news_index_path
    end
  end

  def set_training_cost
    @training_costs = TrainingCost.order(:duration)
  end
end
