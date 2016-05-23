class Backend::EntryTypesController < BackendController
  before_action :set_entry_type, only: [:edit, :update, :destroy, :show_details]
  before_action :set_current_person
  before_action :receptionist_access, only: [:new, :edit, :update, :destroy]
  before_action :employee_access, only: [:index]
  # GET backend/entry_types
  # GET backend/entry_types.json
  def index
    respond_to do |format|
      format.html do
        @entry_types = EntryType.paginate(page: params[:page], per_page: 20)
      end
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
        format.html do
          redirect_to backend_entry_types_path,
                      notice: 'Pomyślnie dodano.'
        end
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT backend/entry_types/1
  # PATCH/PUT backend/entry_types/1.json
  def update
    respond_to do |format|
      if @entry_type.update(entry_type_params)
        format.html do
          redirect_to backend_entry_types_path,
                      notice: 'Pomyślnie zaktualizowano.'
        end
      else
        format.html { render :edit }
      end
    end
  end

  def show
    @tickets = EntryType.where(kind: 'Bilet')
    @passes = EntryType.where(kind: 'Karnet')
  end

  def show_details
  end

  # DELETE backend/entry_types/1
  # DELETE backend/entry_types/1.json
  def destroy
    @entry_type.destroy
    respond_to do |format|
      format.html do
        redirect_to backend_entry_types_path, notice: 'Pomyślnie usunięto.'
      end
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

  def receptionist_access
    unless current_person.type == 'Receptionist'
      flash[:danger] = "Brak dostępu."
      redirect_to backend_news_index_path
    end
  end

  def employee_access
    if current_person.type == 'Client'
      flash[:danger] = "Brak dostępu."
      redirect_to backend_news_index_path
    end
  end

  def require_same_user
    unless current_person.type == 'Receptionist' ||
           current_person.type == 'Manager'
      unless current_person != @person
        flash[:danger] = "Brak dostępu,"
        redirect_to backend_news_index_path
      end
    end
  end
end
