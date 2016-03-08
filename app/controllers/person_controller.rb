class PersonController < ApplicationController


private
  def client_params
    params.require(:client).permit(:pesel, :first_name, :last_name, :email, :date_of_birth, :password, :password_confirmation)
  end
end
