class HomeController < ApplicationController
    def index
        @contact = Contact.new
        @entry_types = EntryType.all
        @tickets = EntryType.where(kind: 'Bilet')
        @passes = EntryType.where(kind: 'Karnet')
        @chipest_ticket = EntryType.order(:price).first
    end
end
