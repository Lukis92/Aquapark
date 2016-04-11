class Backend::BoughtDetailsController < BackendController
    before_action :set_entry_type, only: [:index, :new, :create]
    # GET backend/bought_details
    # GET backend/bought_details.json
    def index
        @bought_details = BoughtDetail.all
        @last_bought = BoughtDetail.order("bought_data").last
    end

    # GET backend/bought_details/new
    def new
        @bought_detail = BoughtDetail.new
    end

    def create
        @bought_detail = BoughtDetail.new(bought_detail_params)
        @bought_detail.entry_type = @entry_type
        @bought_detail.person = current_person

        Stripe.api_key = ENV["STRIPE_API_KEY"]
        token = params[:stripeToken]

        begin
          # customer = Stripe::Customer.create email: @bought_detail.person.email,
          #                                    card: token
          Stripe::Charge.create(
            # :customer => customer.id,
            :amount => (@bought_detail.entry_type.price * 100).floor,
            :currency => "PLN",
            :source => params[:stripeToken]
          )
          flash[:notice] = "Dziękujemy za zakup!"
          @bought_detail.save
          redirect_to backend_entry_type_bought_details_path(@entry_type), notice: flash[:notice]
        rescue Stripe::CardError => e
          flash[:danger] = e.message
          render :new
        end

        # respond_to do |format|
        #     if @bought_detail.save
        #         format.html { redirect_to backend_entry_type_bought_details_path(@entry_type), notice: 'Bought was successfully created.' }
        #         format.json { render :show, status: :created, location: @bought_detail }
        #     else
        #         format.html { render :new }
        #         format.json { render json: @bought_detail.errors, status: :unprocessable_entity }
        #     end
        # end
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
        params.require(:bought_detail).permit(:bought_data, :start_on, :end_on, :entry_type_id, :person_id, :days, :credit_card, :card_code)
    end
end
