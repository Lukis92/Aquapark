# Controller for backend registration actions by devise gem
class Backend::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, only: [:new, :create]
  before_action :set_person
  layout 'backend'
  # GET /resource/sign_up
  def new
    @current_person = current_person
    super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    if resource.save
      flash[:notice] = "Pomyślnie zarejestrowano konto pracownika."
      redirect_to backend_people_path
    else
      flash[:danger] = "Nie udało się zarejestrować konta."
      clean_up_passwords resource
      respond_with resource
    end
  end

  private
  def set_person
    @current_person = current_person
  end
end
