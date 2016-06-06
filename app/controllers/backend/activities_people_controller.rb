class Backend::ActivitiesPeopleController < BackendController
 before_action :set_activities_person, only: [:update, :destroy]
  def index
    @activities_people = ActivitiesPerson.all
  end
  def create
    @activities_person = ActivitiesPerson.new(activities_person_params)
    if @activities_person.save
      redirect_to :back, notice: 'Pomyślnie dodano.'
    else
      redirect_to :back, notice: @activities_person.errors.full_messages
    end
  end

  def update
    if @activities_person.update(activities_person_params)
      redirect_to :back, notice: 'Pomyślnie zaktualizowano.'
    else
      render :edit
    end
  end
  def destroy
    @activities_person.destroy
    redirect_to :back, notice: 'Pomyślnie zrezygnowano'
  end

  private

  def set_activities_person

  end

  def set_activities_person
    @activities_person = ActivitiesPerson.find(params[:id])
  end
  def activities_person_params
    params.require(:activities_person).permit(:date, :person_id, :activity_id)
  end
end
