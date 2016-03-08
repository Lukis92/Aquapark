class Client::ProfileController < ApplicationController
  before_action :set_client, only: [:edit]
  def edit
    #code
  end

  private
    def set_client
      @client = Client.find(params[:id])
    end
end
