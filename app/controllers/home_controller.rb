class HomeController < ApplicationController
  def index
    @contact = Contact.new
    @entry_types = EntryType.all
    @tickets = EntryType.tickets
    @passes = EntryType.passes
    @cheapest_ticket = EntryType.order(:price).first
  end
end
