class Backend::PriceChangesController < BackendController
  before_action :receptionist_access
  before_action :set_priceable

  def index
    @price_changes = @priceable.price_changes.recent_first
                               .paginate(page: params[:page], per_page: 30)
  end

  private

  def set_priceable
    if params[:entry_type_id]
      @priceable = EntryType.find(params[:entry_type_id])
      @priceable_label = "#{@priceable.kind} — #{@priceable.kind_details}"
    elsif params[:training_cost_id]
      @priceable = TrainingCost.find(params[:training_cost_id])
      @priceable_label = "Trening #{@priceable.duration} min."
    else
      redirect_to backend_root_path
    end
  end

  def receptionist_access
    unless current_receptionist || current_manager
      flash[:danger] = 'Brak dostępu.'
      redirect_to backend_news_index_path
    end
  end
end
