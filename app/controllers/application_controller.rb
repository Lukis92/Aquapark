# Main actions for application
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def account_url
    return new_person_session_path unless person_signed_in?
    case current_person.class.name
    when 'Manager'
      backend_managers_path
    when 'Client'
      backend_clients_path
    when 'Receptionist'
      backend_receptionists_path
    when 'Lifeguard'
      backend_lifeguards_path
    when 'Trainer'
      backend_trainers_path
    end if person_signed_in?
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || account_url
  end

  def after_sign_up_path_for(_resource)
    redirect_to client_root_path if current_client
  end

  def logged_in?
    current_person != nil
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)  << :pesel
    devise_parameter_sanitizer.for(:sign_up)  << :first_name
    devise_parameter_sanitizer.for(:sign_up)  << :last_name
    devise_parameter_sanitizer.for(:sign_up)  << :date_of_birth
    devise_parameter_sanitizer.for(:sign_up)  << :profile_image
    devise_parameter_sanitizer.for(:account_update)  << :pesel
    devise_parameter_sanitizer.for(:account_update)  << :first_name
    devise_parameter_sanitizer.for(:account_update)  << :last_name
    devise_parameter_sanitizer.for(:account_update)  << :date_of_birth
    devise_parameter_sanitizer.for(:account_update)  << :profile_image
  end
end
