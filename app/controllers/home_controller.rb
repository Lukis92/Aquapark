class HomeController < ApplicationController
  def index
    @contact = Contact.new
    @tickets = EntryType.tickets
    @passes = EntryType.passes
  end
end
