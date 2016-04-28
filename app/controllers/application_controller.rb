class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    helper_method :current_manager, :current_client, :current_lifeguard, :current_trainer, :current_receptionist,
                  :require_manager!, :require_client!, :require_lifeguard!, :require_trainer!, :require_receptionist!

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

    def current_manager
        @current_manager ||= current_person if person_signed_in? && current_person.class.name == 'Manager'
    end

    def current_client
        @current_client ||= current_person if person_signed_in? && current_person.class.name == 'Client'
    end

    def current_receptionist
        @current_receptionist ||= current_person if person_signed_in? && current_person.class.name == 'Receptionist'
    end

    def current_lifeguard
        @current_lifeguard ||= current_person if person_signed_in? && current_person.class.name == 'Lifeguard'
    end

    def current_trainer
        @current_trainer ||= current_person if person_signed_in? && current_person.class.name == 'Trainer'
    end

    def manager_logged_in?
        (@manager_logged_in ||= person_signed_in?) && current_manager
    end

    def client_logged_in?
        (@client_logged_in ||= person_signed_in?) && current_client
    end

    def receptionist_logged_in?
        (@receptionist_logged_in ||= person_signed_in?) && current_receptionist
    end

    def lifeguard_logged_in?
        (@lifeguard_logged_in ||= person_signed_in?) && current_lifeguard
    end

    def trainer_logged_in?
        (@trainer_logged_in ||= person_signed_in?) && current_trainer
    end

    def require_manager
        require_person_type(:manager)
    end

    def require_client
        require_person_type(:client)
    end

    def require_receptionist
        require_person_type(:receptionist)
    end

    def require_lifeguard
        require_person_type(:lifeguard)
    end

    def require_trainer
        require_person_type(:trainer)
    end

    def require_person_type(person_type)
        if (person_type == :manager && !manager_logged_in?) ||
           (person_type == :client && !client_logged_in?) ||
           (person_type == :receptionist && !receptionist_logged_in?) ||
           (person_type == :lifeguard && !lifeguard_logged_in?) ||
           (person_type == :trainer && !trainer_logged_in?)
            redirect_to root_path, status: 301, notice: "Musisz być zalogowany jako #{'n' if person_type == :admin} #{person_type}, aby uzyskać dostęp"
            return false
        end
    end

    def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up)        << :pesel
        devise_parameter_sanitizer.for(:sign_up)        << :first_name
        devise_parameter_sanitizer.for(:sign_up)        << :last_name
        devise_parameter_sanitizer.for(:sign_up)        << :date_of_birth
        devise_parameter_sanitizer.for(:account_update) << :pesel
        devise_parameter_sanitizer.for(:account_update) << :first_name
        devise_parameter_sanitizer.for(:account_update) << :last_name
        devise_parameter_sanitizer.for(:account_update) << :date_of_birth
    end
end
