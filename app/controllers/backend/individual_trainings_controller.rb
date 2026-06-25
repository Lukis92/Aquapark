class Backend::IndividualTrainingsController < BackendController
  before_action :set_individual_training, only: [:edit, :update, :destroy]
  before_action :set_trainer, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_client, only: [:show_details, :new, :create, :edit, :update, :destroy]
  before_action :set_person, only: [:show, :show_details]
  before_action :set_training_cost, except: :index
  before_action :select_rule_own_trainings, only: [:show]
  before_action :set_rule_to_join, only: [:choose_trainer]
  include Sortable
  helper_method :sort_column
  def index
    @clients  = Client.order(:first_name, :last_name)
    @trainers = Trainer.order(:first_name, :last_name)

    scope = IndividualTraining.includes(:training_cost, :client, :trainer)
                              .references(:training_costs, :clients)

    scope = scope.where(client_id: params[:client_id])   if params[:client_id].present?
    scope = scope.where(trainer_id: params[:trainer_id]) if params[:trainer_id].present?
    scope = scope.where(date_of_training: params[:date_from]..) if params[:date_from].present?
    scope = scope.where(date_of_training: ..params[:date_to])   if params[:date_to].present?

    @individual_trainings = scope.order(Arel.sql("#{sort_column} #{sort_direction}"))
                                 .paginate(page: params[:page], per_page: 20)
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

    unless @individual_training.valid?
      render :new and return
    end

    begin
      charge = Stripe::Charge.create(
        amount: (@individual_training.training_cost.cost * 100).floor,
        currency: 'pln',
        source: token
      )

      unless @individual_training.save
        Stripe::Refund.create(charge: charge.id) rescue nil
        flash[:danger] = 'Wystąpił błąd podczas zapisu. Płatność została zwrócona.'
        render :new and return
      end

      training_info = "#{l(@individual_training.date_of_training)} #{l(@individual_training.start_on, format: :short)}–#{l(@individual_training.end_on, format: :short)}"
      Notification.notify(
        person:     @individual_training.trainer,
        actor:      current_person,
        kind:       'individual_training_assigned',
        message:    "Przypisano nowy trening indywidualny: #{training_info} z klientem #{@individual_training.client.full_name}.",
        notifiable: @individual_training
      )
      redirect_to show_backend_individual_trainings_path(@client),
                  notice: 'Pomyślnie dodano.'
    rescue Stripe::CardError => e
      flash[:danger] = e.message
      render :new
    end
  end

  # GET backend/people/:id/trainers/:trainer_id/individual_trainings/:id
  def edit
  end

  # PATCH/PUT backend/individual_trainings/1
  def update
    if @individual_training.update(individual_training_params)
      safe_redirect_back notice: 'Pomyślnie zaktualizowano.'
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
    training_info = "#{l(@individual_training.date_of_training)} #{l(@individual_training.start_on, format: :short)}–#{l(@individual_training.end_on, format: :short)}"
    trainer = @individual_training.trainer
    client  = @individual_training.client
    @individual_training.destroy
    [trainer, client].uniq.each do |person|
      next if person == current_person
      Notification.notify(
        person:  person,
        actor:   current_person,
        kind:    'individual_training_cancelled',
        message: "Anulowano trening indywidualny: #{training_info}."
      )
    end
    safe_redirect_back notice: 'Pomyślnie usunięto.'
  end

  def choose_trainer
    @trainers = Person.includes(:work_schedules).where(type: 'Trainer')
                      .where.not(work_schedules: { person_id: nil })
    @trainers = @trainers.where(work_schedules: { day_of_week: params[:day_of_week] }) if params[:day_of_week].present?
    @trainers = @trainers.paginate(page: params[:page], per_page: 20)
  end

  # GET backend/individual_trainings/search
  def search
    @individual_trainings = IndividualTraining.text_search(params[:query], params[:querydate])
                                              .paginate(page: params[:page],
                                                        per_page: 20)
  end

  private

  def individual_training_params
    params.require(:individual_training)
          .permit(:cost, :date_of_training, :start_on, :end_on, :client_id,
                  :trainer_id, :training_cost_id, :duration, :day, :credit_card,
                  :card_code, :stripe_secret_key, :stripe_publishable_key)
  end

  def set_individual_training
    if params[:ind_training_id].present?
      @individual_training = IndividualTraining.find(params[:ind_training_id])
    else
      @individual_training = IndividualTraining.find(params[:id])
    end
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
      flash[:danger] = 'Brak dostępu'
      redirect_to backend_news_index_path
    end
  end

  def set_rule_to_join
    unless current_client
      flash[:danger] = 'Brak dostępu'
      redirect_to backend_news_index_path
    end
  end

  def sort_column
    sortable_column(IndividualTraining, default: 'date_of_training',
                    joined: %w(training_costs.cost training_costs.duration clients.first_name))
  end
end
