class Backend::EntryTypesController < BackendController
    before_action :set_entry_type, only: [:edit, :update, :destroy, :show_details]
    before_action :set_current_person

    # GET backend/entry_types
    # GET backend/entry_types.json
    def index
        respond_to do |format|
            format.html { @entry_types = EntryType.paginate(page: params[:page], per_page: 5) }
            format.json { @entry_types = EntryType.all }
        end
    end

    # GET backend/entry_types/new
    def new
        @entry_type = EntryType.new
    end

    # POST backend/entry_types
    # POST backend/entry_types.json
    def create
        @entry_type = EntryType.new(entry_type_params)
        respond_to do |format|
            if @entry_type.save
                format.html { redirect_to backend_entry_types_path, notice: 'Pomyślnie dodano.' }
                format.json { render :show, status: :created, location: @entry_type }
            else
                format.html { render :new }
                format.json { render json: @entry_type.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT backend/entry_types/1
    # PATCH/PUT backend/entry_types/1.json
    def update
        respond_to do |format|
            if @entry_type.update(entry_type_params)
                format.html { redirect_to backend_entry_types_path, notice: 'Pomyślnie zaktualizowano.' }
                format.json { render :show, status: :ok, location: @entry_type }
            else
                format.html { render :edit }
                format.json { render json: @entry_type.errors, status: :unprocessable_entity }
            end
        end
    end

    def show
      @tickets = EntryType.where(kind: "Bilet")
      @passes = EntryType.where(kind: "Karnet")
    end

    def show_details

    end

    # DELETE backend/entry_types/1
    # DELETE backend/entry_types/1.json
    def destroy
        @entry_type.destroy
        respond_to do |format|
            format.html { redirect_to backend_entry_types_path, notice: 'Pomyślnie usunięto.' }
            format.json { head :no_content }
        end
    end

    private

    def entry_type_params
        params.require(:entry_type).permit(:kind, :kind_details, :price)
    end

    def set_entry_type
        @entry_type = EntryType.find(params[:id])
    end

    def set_current_person
        @current_person = current_person
    end
end
