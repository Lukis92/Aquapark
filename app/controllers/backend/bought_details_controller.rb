class Backend::BoughtDetailsController < BackendController
  helper_method :sort_bought, :sort_direction
  before_action :set_entry_type, only: [:index, :new, :create]
  before_action :set_bought_detail,
                only: [:edit, :destroy, :activate, :deactivate]
  before_action :set_rule_to_display_bought_details, only: [:index]
  # GET backend/bought_details
  # GET backend/bought_details.json
  def index
    @bought_details = BoughtDetail.includes(:person)
                                  .order(sort_bought + ' ' + sort_direction)
                                  .references(:people)
                                  .where(entry_type_id: @entry_type)
                                  .paginate(page: params[:page], per_page: 20)
    @last_bought = BoughtDetail.where(entry_type_id: @entry_type)
                               .order('bought_data').last
  end

  # GET backend/bought_details/new
  def new
    @bought_detail = BoughtDetail.new
  end

  def create
    @bought_detail = BoughtDetail.new(bought_detail_params)
    @bought_detail.entry_type = @entry_type
    @bought_detail.person = current_person
    if @bought_detail.entry_type.kind == 'Karnet'
      @bought_detail.cost = @bought_detail.entry_type.price *
                            (@bought_detail.days.to_i / 30).floor
    else
      @bought_detail.cost = @bought_detail.entry_type.price
    end

    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        amount: (@bought_detail.cost * 100).floor,
        currency: 'pln',
        card: token
      )

    rescue Stripe::CardError => e
      @bought_detail.destroy
      flash[:danger] = e.message
      render :new
    end

    if @bought_detail.save
      flash[:notice] = "Dziękujemy za zakup!"
      redirect_to bought_history_backend_person_path(current_person),
                  notice: flash[:notice]
    else
      flash[:danger] = @bought_detail.errors.full_messages
      charge = nil
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = params[:stripeToken]
      render :new, notice: flash[:danger]
    end
  end

  # DELETE backend/work_schedules/1
  # DELETE backend/work_schedules/1.json
  def destroy
    @bought_detail.destroy
    redirect_to backend_entry_type_bought_details_path,
                notice: 'Pomyślnie usunięto.'
  end

  private

  def set_entry_type
    @entry_type = EntryType.find(params[:entry_type_id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie istnieje wejściówka o takim id.'
    redirect_to backend_news_index_path
  end

  def set_bought_detail
    @bought_detail = BoughtDetail.find(params[:id])
  end

  JOINED_TABLE_COLUMNS = %w(people.first_name).freeze
  def sort_bought
    if JOINED_TABLE_COLUMNS.include?(params[:sort]) || BoughtDetail.column_names.include?(params[:sort])
      params[:sort]
    else
      'bought_data'
    end
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

  # only allow the white list through.
  def bought_detail_params
    params.require(:bought_detail).permit(:bought_data, :start_on, :end_on,
                                          :entry_type_id, :days, :person_id,
                                          :credit_card, :card_code)
  end

  def set_rule_to_display_bought_details
    unless current_manager || current_receptionist
      flash[:danger] = 'Brak dostępu.'
      redirect_to backend_news_index_path
    end
  end
end
