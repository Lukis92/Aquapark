class Backend::ActivitiesController < BackendController
  before_action :set_activity, only: [:edit, :update, :destroy]

  # GET backend/activities
  def index
    @activities = Activity.paginate(page: params[:page],
                                    per_page: 20)
  end

  # GET backend/activities/new
  def new
    @activity = Activity.new
  end

  # POST backend/activities
  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to backend_activities_path, notice: 'Pomyślnie dodano.'
    else
      render :new
    end
  end

  # PATCH/PUT backend/activities/1
  def update
    if @activity.update(activity_params)
      redirect_to backend_activities_path,
                  notice: 'Pomyślnie zaktualizowano.'
    else
      render :edit
    end
  end

  # DELETE backend/activities/1
  def destroy
    @activity.destroy
    redirect_to :back, notice: 'Pomyślnie usunięto.'
  end

  # GET backend/activities/search
  def search
    if params[:query].present?
      @activities = Activity.text_search(params[:query])
                          .paginate(page: params[:page],
                                    per_page: 20)
    end
  end

  private

  def activity_params
    params.require(:activity)
          .permit(:name, :description, :active, :date, :start_on, :end_on,
                  :pool_zone, :max_people)
  end

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_person
    @person = Person.find(params[:id])
  end

  def set_employees
    @employees = Person.where.not(type: 'Client')
  end
end
