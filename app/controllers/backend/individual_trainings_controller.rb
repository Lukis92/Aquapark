class Backend::IndividualTrainingsController < BackendController
  before_action :set_individual_training, only: [:edit, :update, :destroy]
  before_action :set_clients
  before_action :set_trainers
  before_action :set_trainer
  before_action :set_client
  before_action :set_training_cost

  def index
    @individual_trainings = IndividualTraining.paginate(page: params[:page],
                                                        per_page: 20)
  end

  # GET backend/individual_trainings/new
  def new
    @individual_training = IndividualTraining.new
    @individual_trainings = IndividualTraining.all
  end

  # POST backend/individual_trainings
  def create
    @individual_training = IndividualTraining.new(individual_training_params)
    if @individual_training.save
      redirect_to :back, notice: 'Pomyślnie dodano.'
    else
      render :new
    end
  end

  # PATCH/PUT backend/individual_trainings/1
  def update
    if @individual_training.update(individual_training_params)
      redirect_to :back, notice: 'Pomyślnie zaktualizowano.'
    else
      render :edit
    end
  end

  def show
    @individual_trainings = IndividualTraining.where(client_id: params[:id])
    @nearest_training = IndividualTraining.where(client_id: params[:id])
                                          .where(['date_of_training >= ?',
                                                  Date.today]).first
    @days = 0

    unless @nearest_training.blank?
      @days = (@nearest_training.date_of_training - Date.today).to_i
    end
  end

  # DELETE backend/individual_trainings/1
  # DELETE backend/individual_trainings/1.json
  def destroy
    @individual_training.destroy
    redirect_to :back, notice: 'Pomyślnie usunięto.'
  end

  def choose_trainer
    @trainers = Person.includes(:work_schedules).where(type: 'Trainer')
                      .where.not(work_schedules: { person_id: nil })
                      .paginate(page: params[:page], per_page: 20)
  end

  # GET backend/individual_trainings/search
  def search
    if params[:query].present?
      @individual_trainings = IndividualTraining.text_search(params[:query])
                                                .paginate(page: params[:page],
                                                          per_page: 20)
    end
  end

  private

  def individual_training_params
    params.require(:individual_training)
          .permit(:cost, :date_of_training, :start_on, :end_on, :client_id,
                  :trainer_id, :training_cost_id, :duration, :day)
  end

  def set_individual_training
    @individual_training = IndividualTraining.find(params[:id])
  end

  def set_clients
    @clients = Person.where(type: 'Client')
  end

  def set_trainers
    @trainers = Person.where(type: 'Trainer')
  end

  def set_trainer
    @trainer = Trainer.find(params[:trainer_id]) unless params[:trainer_id].blank?
  end

  def set_client
    @client = Person.find(params[:id]) unless params[:id].blank?
  end

  def set_training_cost
    @training_costs = TrainingCost.order(:duration)
  end
end
