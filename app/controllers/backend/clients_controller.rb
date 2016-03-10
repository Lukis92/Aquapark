class Backend::ClientsController < BackendController
  before_action :set_client, only: [:show_profile]
  def index
    #code
  end

  def show_profile
    #code
  end

  private
    def set_client
      @client = Client.find(params[:id])
    end
end
