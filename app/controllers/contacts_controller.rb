class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      redirect_to "/#contact"
      flash[:notice] = 'Dziękujemy za wiadomość. Postaramy się odpowiedzieć jak najszybciej.'
    else
      flash[:error] = 'Nie można wysłać wiadomości.'
      render :new
    end
  end
end
