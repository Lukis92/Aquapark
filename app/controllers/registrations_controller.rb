class RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    if current_manager
      resource.update_without_password(params)
    else
      super
    end
  end
  def after_sign_up_path_for(resource)
    redirect_to new_person_session_path
  end
end
