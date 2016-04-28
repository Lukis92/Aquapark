class ContactsController < ApplicationController
    def new
        @contact = Contact.new
    end

    def create
        @contact = Contact.new(params[:contact])
        @contact.request = request
        if @contact.deliver
            redirect_to '/#contact' # Powinienes przekazac poprawny path.
            flash[:notice] = 'Dziękujemy za wiadomość. Postaramy się odpowiedzieć jak najszybciej.'
        else
            flash[:error] = 'Nie można wysłać wiadomości sprawdz komunikaty.' # Powinienes przekazac dlaczego.
            render :new
        end
    end
end
