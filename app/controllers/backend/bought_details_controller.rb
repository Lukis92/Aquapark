class Backend::BoughtDetailsController < BackendController
  before_action :set_entry_type, only: [:new]
  # GET backend/bought_details
  # GET backend/bought_details.json
  def index
    @bought_details = BoughtDetail.all
  end

  # GET backend/bought_details/new
  def new
    @bought_detail = BoughtDetail.new
  end

  private
  def set_entry_type
    @entry_type = EntryType.find(params[:id])
  end
end
