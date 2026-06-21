class Backend::EntryTypesController < BackendController
  include Sortable
  helper_method :sort_column
  before_action :set_entry_type, only: [:edit, :update, :destroy, :show_details]
  before_action :receptionist_access, only: [:new, :edit, :update, :destroy]
  before_action :employee_access, only: [:index]

  # GET backend/entry_types
  def index
    scope = EntryType.all
    scope = scope.where(kind: params[:kind])                                        if params[:kind].present?
    scope = scope.where('kind_details ILIKE ?', "%#{params[:kind_details]}%") if params[:kind_details].present?
    @entry_types = scope.order(Arel.sql("#{sort_column} #{sort_direction}"))
                        .paginate(page: params[:page], per_page: 20)
  end

  # GET backend/entry_types/new
  def new
    @entry_type = EntryType.new
  end

  # POST backend/entry_types
  def create
    @entry_type = EntryType.new(entry_type_params)
    if @entry_type.save
      redirect_to backend_entry_types_path, notice: 'Pomyślnie dodano.'
    else
      render :new
    end
  end

  # GET backend/entry_types/:id/edit
  def edit
  end

  # PATCH/PUT backend/entry_types/1
  def update
    if @entry_type.update(entry_type_params)
      redirect_to backend_entry_types_path, notice: 'Pomyślnie zaktualizowano.'
    else
      render :edit
    end
  end

  def show
    @tickets = EntryType.order(Arel.sql("#{sort_column} #{sort_direction}")).where(kind: 'Bilet')
    @passes = EntryType.order(Arel.sql("#{sort_column} #{sort_direction}")).where(kind: 'Karnet')
  end

  def show_details
  end

  # DELETE backend/entry_types/1
  def destroy
    @entry_type.destroy
    redirect_to backend_entry_types_path, notice: 'Pomyślnie usunięto.'
  end

  # GET backend/entry_types/search
  def search
    if params[:query].present?
      @entry_types = EntryType.order(Arel.sql("#{sort_column} #{sort_direction}"))
                              .text_search(params[:query])
                              .paginate(page: params[:page], per_page: 20)
    end
  end

  private

  def entry_type_params
    params.require(:entry_type).permit(:kind, :kind_details, :description, :price)
  end

  def set_entry_type
    @entry_type = EntryType.find(params[:id])
  end

  def sort_column
    sortable_column(EntryType, default: 'price')
  end

  def receptionist_access
    unless current_receptionist || current_manager
      flash[:danger] = 'Brak dostępu. {receptionist_access}'
      redirect_to backend_news_index_path
    end
  end

  def employee_access
    if current_client
      flash[:danger] = 'Brak dostępu. {employee_access}'
      redirect_to backend_news_index_path
    end
  end
end
