# Controller to contact form on main page
class ContactsController < ApplicationController
  # Display the contact form.
  def new
    @contact = Contact.new
  end

  # Process the submitted contact form and send email.
  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      redirect_to '/#contact' # Powinienes przekazac poprawny path.
      flash[:notice] = 'Dziękujemy za wiadomość. Postaramy się odpowiedzieć
                        jak najszybciej.'
    else
      # Powinienes przekazac dlaczego.
      # flash[:error] = 'Nie można wysłać wiadomości sprawdz komunikaty.'
      render :new, error: "Nie można wysłać wiadomości sprawdz komunikaty."
    end
  end
end
