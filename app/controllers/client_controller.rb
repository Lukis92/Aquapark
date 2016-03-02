# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ClientsController < ApplicationController

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Pomyślnie dodano.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:pesel, :first_name, :last_name, :email, :password_digest)
    end
  end
end
