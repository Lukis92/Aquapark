class Backend::NotificationsController < BackendController
  def index
    scope = current_manager ? Notification.all : current_person.notifications

    scope = scope.where(read_at: nil)          if params[:unread].present?
    if current_manager
      scope = scope.joins(:person).where(people: { type: params[:person_type] }) if params[:person_type].present?
      scope = scope.where(person_id: params[:person_id]) if params[:person_id].present?
    end
    scope = scope.where(kind: params[:kind])   if params[:kind].present?

    @notifications = scope.includes(:person, :actor).recent
                          .paginate(page: params[:page], per_page: 30)

    if current_manager
      people_scope = params[:person_type].present? ? Person.where(type: params[:person_type]) : Person.all
      @people_for_filter = people_scope.order(:first_name, :last_name)
    end
  end

  def mark_as_read
    notification = current_manager ? Notification.find(params[:id])
                                   : current_person.notifications.find(params[:id])
    notification.mark_as_read!
    redirect_back fallback_location: backend_notifications_path
  end

  def mark_all_as_read
    scope = current_manager ? Notification.all : current_person.notifications
    scope.unread.update_all(read_at: Time.current)
    redirect_to backend_notifications_path, notice: 'Wszystkie powiadomienia oznaczone jako przeczytane.'
  end
end
