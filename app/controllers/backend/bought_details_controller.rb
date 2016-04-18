class Backend::BoughtDetailsController < BackendController
    load_and_authorize_resource
    before_action :set_entry_type, only: [:index, :new, :create]
    # GET backend/bought_details
    # GET backend/bought_details.json
    def index
        @bought_details = BoughtDetail.all
        @last_bought = BoughtDetail.order('bought_data').last
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
            @bought_detail.cost = @bought_detail.entry_type.price * (@bought_detail.days.to_i / 30).floor
        else
            @bought_detail.cost = @bought_detail.entry_type.price
        end
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
        token = params[:stripeToken]

        begin
            charge = Stripe::Charge.create(
                amount: (@bought_detail.entry_type.price * 100).floor,
                currency: 'pln',
                card: token
            )

            if @bought_detail.save
                flash[:notice] = "Dziękujemy za zakup!"
                redirect_to backend_entry_type_bought_details_path(@entry_type), notice: flash[:notice]
            else
                flash[:danger] = @bought_detail.errors.full_messages
                render :new, notice: flash[:danger]
            end

        rescue Stripe::CardError => e
            flash[:danger] = e.message
            render :new
        end
    end

    # DELETE backend/work_schedules/1
    # DELETE backend/work_schedules/1.json
    def destroy
        @bought_detail.destroy
        respond_to do |format|
            format.html { redirect_to backend_work_schedules_path, notice: 'Pomyślnie usunięto.' }
            format.json { head :no_content }
        end
    end

    private

    def set_entry_type
        @entry_type = EntryType.find(params[:entry_type_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bought_detail_params
        params.require(:bought_detail).permit(:bought_data, :start_on, :end_on, :entry_type_id, :days, :person_id, :credit_card, :card_code)
    end
end
