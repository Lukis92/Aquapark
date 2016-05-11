class Backend::IndividualTrainingsController < BackendController
  before_action :set_individual_training, only: [:edit, :update, :destroy]
  before_action :set_clients
  before_action :set_trainers
  before_action :set_trainer, only: [:new]

  @@trainer = 0
  def index
    @individual_trainings = IndividualTraining.paginate(page: params[:page],
                                                        per_page: 20)
  end

  # GET backend/individual_trainings/new
  def new
    @individual_training = IndividualTraining.new
    @@trainer = @trainer
    @training_costs = TrainingCost.all
  end

  # POST backend/individual_trainings
  def create
    @individual_training = IndividualTraining.new(individual_training_params)
    @individual_training.trainer = @@trainer

    respond_to do |format|
      if @individual_training.save
        format.html { redirect_to :back, notice: 'Pomyślnie dodano.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT backend/individual_trainings/1
  def update
    respond_to do |format|
      if @individual_training.update(individual_training_params)
        format.html { redirect_to :back, notice: 'Pomyślnie zaktualizowano.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE backend/individual_trainings/1
  # DELETE backend/individual_trainings/1.json
  def destroy
    @individual_training.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Pomyślnie usunięto.' }
    end
  end

  def choose_trainer
    @trainers = Person.includes(:work_schedules).where(type: 'Trainer')
                      .where.not(work_schedules: { person_id: nil })
                      .paginate(page: params[:page], per_page: 20)
  end

  def choose_date
    @trainer = Person.find(params[:trainer_id])
    @individual_training = IndividualTraining.new
    @individual_training.trainer = @trainer
    raise 'Dupa'
  end

  private

  def individual_training_params
    params.require(:individual_training)
          .permit(:cost, :date_of_training, :start_on, :end_on, :client_id,
                  :trainer_id, :duration, :day)
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
    @trainer = Person.find(params[:trainer_id])
  end
end
