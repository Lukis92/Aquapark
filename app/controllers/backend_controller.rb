# Controller for backend pages
class BackendController < ApplicationController
  before_action :require_person
  before_action :set_current_person
  layout 'backend'
  def show
  end

  # to get various helper method like "current_user" and "authenticate_user"
  %w(Manager Receptionist Lifeguard Trainer).each do |k|
    define_method "current_#{k.underscore}" do
      current_person if current_person.is_a?(k.constantize)
    end

    define_method "authenticate_#{k.underscore}!" do |_opts = {}|
      send("current_#{k.underscore}") || not_authorized
    end

    define_method "#{k.underscore}_signed_in?" do
      !send("current_#{k.underscore}").nil?
    end
  end

  private

  def require_person
    unless current_person.present?
      flash[:danger] = 'Brak dostępu.'
      redirect_to root_path
    end
  end

  def set_current_person
    @current_person = current_person unless current_person.blank?
  end
end
