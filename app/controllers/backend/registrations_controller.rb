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

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  private

  def set_person
    @current_person = current_person
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)  << :pesel
    devise_parameter_sanitizer.for(:sign_up)  << :first_name
    devise_parameter_sanitizer.for(:sign_up)  << :last_name
    devise_parameter_sanitizer.for(:sign_up)  << :date_of_birth
    devise_parameter_sanitizer.for(:sign_up)  << :profile_image
    devise_parameter_sanitizer.for(:sign_up)  << :salary
    devise_parameter_sanitizer.for(:sign_up)  << :hiredate
    devise_parameter_sanitizer.for(:sign_up)  << :type
    devise_parameter_sanitizer.for(:sign_up)  << :password
    devise_parameter_sanitizer.for(:sign_up)  << :password_confirmation
    devise_parameter_sanitizer.for(:account_update)  << :pesel
    devise_parameter_sanitizer.for(:account_update)  << :first_name
    devise_parameter_sanitizer.for(:account_update)  << :last_name
    devise_parameter_sanitizer.for(:account_update)  << :date_of_birth
    devise_parameter_sanitizer.for(:account_update)  << :profile_image
    devise_parameter_sanitizer.for(:account_update)  << :salary
    devise_parameter_sanitizer.for(:account_update)  << :hiredate
    devise_parameter_sanitizer.for(:account_update)  << :type
    devise_parameter_sanitizer.for(:account_update)  << :password
    devise_parameter_sanitizer.for(:account_update)  << :password_confirmation
  end
end
