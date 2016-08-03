class Backend::IndividualTrainingsController < BackendController
  before_action :set_individual_training, only: [:edit, :update, :destroy]
  before_action :set_trainer, only: [:create, :edit, :update, :destroy]
  # except: [:index, :show, :show_details, :choose_trainer, :search]
  before_action :set_client, only: [:show, :show_details, :new, :create, :edit, :update, :destroy]
  before_action :set_person, only: [:show, :show_details]
  before_action :set_training_cost, except: :index
  before_action :select_rule_own_trainings, only: [:show]

  def index
    @individual_trainings = IndividualTraining.paginate(page: params[:page],
                                                        per_page: 20)
    @manage_trainings = @individual_trainings
  end

  # GET backend/individual_trainings/new
  def new
    @individual_training = IndividualTraining.new
    @individual_trainings = IndividualTraining.all
  end

  # POST backend/individual_trainings
  def create
    @individual_training = IndividualTraining.new(individual_training_params)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    token = params[:stripeToken]
    if @individual_training.valid?
      begin
        charge = Stripe::Charge.create(
          amount: (@individual_training.training_cost.cost * 100).floor,
          currency: 'pln',
          card: token
        )
        if @individual_training.save
          redirect_to show_backend_individual_trainings_path(@client), notice: 'Pomyślnie dodano.'
        else
          render :new
        end
      rescue Stripe::CardError => e
        flash[:danger] = e.message
        render :new
      end
    else
      render :new
    end
  end

  # GET backend/people/:id/trainers/:trainer_id/individual_trainings/:id
  def edit
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
    @individual_trainings = IndividualTraining.where(client_id: params[:id]).order(:start_on)
    @trainer_individual_trainings = IndividualTraining.where(trainer_id: params[:id]).order(:start_on)
    @nearest_training = IndividualTraining.where(client_id: params[:id])
                                          .where(['date_of_training >= ?',
                                                  Date.today])
                                          .where('start_on > ?', Time.now).first
    @days = 0
    unless @nearest_training.blank?
      @days = (@nearest_training.date_of_training - Date.today).to_i
    end
  end

  def show_details
    @individual_trainings = IndividualTraining.where(client_id: @client)
                                              .where(date_of_training: params[:date_of_training])
                                              .order(:start_on)
    @trainer_ind_trainings = IndividualTraining.where(trainer_id: @person)
                                               .where(date_of_training: params[:date_of_training])
                                               .order(:start_on)
  end

  # DELETE backend/individual_trainings/1
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
      @individual_trainings = IndividualTraining.text_search(params[:query], params[:querydate])
                                                .paginate(page: params[:page],
                                                          per_page: 20)
    end
  end

  private

  def individual_training_params
    params.require(:individual_training)
          .permit(:cost, :date_of_training, :start_on, :end_on, :client_id,
                  :trainer_id, :training_cost_id, :duration, :day, :credit_card,
                  :card_code, :stripe_secret_key, :stripe_publishable_key)
  end

  def set_individual_training
    @individual_training = IndividualTraining.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie istnieje indywidualny trening o takim id.'
    redirect_to backend_news_index_path
  end

  def set_trainer
    @trainer = Trainer.find(params[:trainer_id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie istnieje trener o takim id.'
    redirect_to backend_news_index_path
  end

  def set_ind_trainer
    @trainer_ind = Trainer.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie istnieje trener o takim id.'
    redirect_to backend_news_index_path
  end

  def set_client
    @client = Client.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie istnieje client o takim id.'
    redirect_to backend_news_index_path
  end

  def set_person
    @person = Person.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie istnieje osoba o takim id.'
    redirect_to backend_news_index_path
  end

  def set_training_cost
    @training_costs = TrainingCost.order(:duration)
  end

  def select_rule_own_trainings
    unless current_manager || current_receptionist || current_person == @person
      flash[:danger] = "Brak dostępu"
      redirect_to backend_news_index_path
    end
  end
end
