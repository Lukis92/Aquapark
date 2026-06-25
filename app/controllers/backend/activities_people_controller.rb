class Backend::ActivitiesPeopleController < BackendController
 before_action :set_activities_person, only: [:update, :destroy]
  def index
    @activities_people = ActivitiesPerson.all
  end
  def create
    @activities_person = ActivitiesPerson.new(activities_person_params)
    if @activities_person.save
      activity = @activities_person.activity
      client   = @activities_person.person
      recipient = activity.person || Manager.first
      if recipient
        Notification.notify(
          person:     recipient,
          actor:      client,
          kind:       'activity_signup',
          message:    "#{client.full_name} zapisał(a) się na zajęcia \"#{activity.name}\" (#{activity.day_of_week}, #{l(activity.start_on, format: :short)}).",
          notifiable: @activities_person
        )
      end
      flash[:notice] = 'Pomyślnie dodano.'
      safe_redirect_back
    else
      flash[:danger] = "#{@activities_person.errors.full_messages.join('')}"
      safe_redirect_back
    end
  end

  def update
    if @activities_person.update(activities_person_params)
      safe_redirect_back notice: 'Pomyślnie zaktualizowano.'
    else
      render :edit
    end
  end
  def destroy
    activity  = @activities_person.activity
    client    = @activities_person.person
    recipient = activity.person || Manager.first
    @activities_person.destroy
    if recipient && client != current_person
      Notification.notify(
        person:  recipient,
        actor:   current_person,
        kind:    'activity_resign',
        message: "#{client.full_name} zrezygnował(a) z zajęć \"#{activity.name}\" (#{activity.day_of_week}, #{l(activity.start_on, format: :short)})."
      )
    end
    safe_redirect_back notice: 'Pomyślnie zrezygnowano'
  end

  private

  def set_activities_person
    begin
      @activities_person = ActivitiesPerson.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      flash[:danger] = 'Nie istnieje aktywność o takim id.'
      redirect_to backend_news_index_path
    end
  end
  def activities_person_params
    params.require(:activities_person).permit(:date, :person_id, :activity_id)
  end
end
