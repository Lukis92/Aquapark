# Controller for backend registration actions by devise gem
class Backend::RegistrationsController < Devise::RegistrationsController
  layout 'backend'
  # GET /resource/sign_up
  def new
    @current_person = current_person
    super
  end

  # POST /resource
  def create
    super
  end
end
