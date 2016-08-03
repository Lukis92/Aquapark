class ApplicationController < ActionController::Base
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
    redirect_to new_person_session, notice: 'Zarejestrowano konto pomyślnie.'
  end

  def logged_in?
    current_person != nil
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
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
      u.permit(sanitized_params)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
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
      u.permit(sanitized_params)
    end
  end
end
