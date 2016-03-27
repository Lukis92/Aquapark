class HomeController < ApplicationController
  def index
    @contact = Contact.new
    @entry_types = EntryType.all
  end
end
