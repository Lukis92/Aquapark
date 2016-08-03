# Controller for backend registration actions by devise gem
class Backend::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, only: [:new, :create]
  layout 'backend'
  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    if resource.save
      flash[:notice] = 'Pomyślnie zarejestrowano konto pracownika.'
      redirect_to backend_people_path
    else
      flash[:danger] = 'Nie udało się zarejestrować konta.'
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  private

  def configure_permitted_parameters
    sanitized_params = %i(
      pesel
      first_name
      last_name
      date_of_birth
      profile_image
      salary
      hiredate
      type
      password
      password_confirmation
    )
    devise_parameter_sanitizer.permit(:sign_up, keys: sanitized_params)
    devise_parameter_sanitizer.permit(:account_update, keys: sanitized_params)
  end
end
