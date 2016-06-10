# Main actions for application
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActionController::RoutingError, with: :error_render_method

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || backend_news_index_path
  end

  def error_render_method
    respond_to do |type|
      type.xml { render template: 'errors/error_404', status: 404 }
      type.all { render nothing: true, status: 404 }
    end
    true
  end

  def after_sign_up_path_for(resource)
    redirect_to new_person_session, notice: "Zarejestrowano konto pomyślnie."
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
