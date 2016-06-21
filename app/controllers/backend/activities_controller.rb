class Backend::ActivitiesController < BackendController
  helper_method :sort_column, :sort_direction
  before_action :set_activity, only: [:edit, :update, :destroy, :sign_up,
                                      :preview, :activate, :deactivate]
  before_action :set_trainers
  before_action :set_person, only: :sign_up
  before_action :set_zone, only: :pool_zone
  before_action :set_rule_to_manage, only: [:edit, :update, :destroy, :activate,
                                            :deactivate]
  # GET backend/activities
  def index
    @activities = Activity.includes(:person)
                          .order(sort_column + ' ' + sort_direction)
                          .references(:people)
                          .paginate(page: params[:page], per_page: 20)
    @actual_activities = Activity.includes(:person)
                                 .order(sort_column + ' ' + sort_direction)
                                 .references(:people)
                                 .where('active = ?', true)
                                 .paginate(page: params[:page], per_page: 20)
    @active_activities = ActivitiesPerson.includes(:person)
                                         .order(sort_column + ' ' + sort_direction)
                                         .references(:people)
                                         .where('activity.active = ?', true)
                                         .paginate(page: params[:page], per_page: 20)
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

  def activate
    @activity.update!(active: true)
    redirect_to :back, notice: 'Aktywowano.'
  end

  def deactivate
    @activity.update!(active: false)
    @activities_people = ActivitiesPerson.where(activity_id: @activity).where('date >= ?', Date.today)
    @activities_people.each do |ap|
      ap.destroy
    end
    redirect_to :back, notice: 'Deaktywowano.'
  end

  def requests
    @activity_requests = Activity.where(active: false)
                                 .paginate(page: params[:page], per_page: 20)
  end

  def pool_zone
    @activities_people = Activity.where(activities: { pool_zone: @zone, active: true }).order(start_on: :asc)
    @act_people = ActivitiesPerson.where(activity_id: :activity_id)
                                  .includes(:activity).includes(:activities_people)
  end

  # DELETE backend/activities/1
  def destroy
    @activity.destroy
    redirect_to :back, notice: 'Pomyślnie usunięto.'
  end

  def preview
    @activities_people = @activity.activities_people
                                  .select(:activity_id, :date)
                                  .order(:date)
                                  .distinct
  end

  # GET backend/activities/search
  def search
    if params[:query].present?
      @activities = Activity.text_search(params[:query])
                            .paginate(page: params[:page],
                                      per_page: 20)
    end
  end

  def sign_up
    @activities_person = ActivitiesPerson.new
    @activities_people = ActivitiesPerson.where('activity_id = ?', @activity.id)
                                         .where('person_id = ?', @person.id)
  end

  private

  def activity_params
    params.require(:activity)
          .permit(:name, :description, :active, :day_of_week, :start_on, :end_on,
                  :pool_zone, :max_people, :person_id, activities_people: [:date])
  end

  # check if activity is active
  def check_activity
    unless @activity.active == true
      errors.add(:error, 'Nie możesz dołączać do nie aktywnych zajęć.')
    end
  end

  JOINED_TABLE_COLUMNS = %w(people.first_name)
  def sort_column
    if JOINED_TABLE_COLUMNS.include?(params[:sort]) || Activity.column_names.include?(params[:sort])
      params[:sort]
    else
      'name'
    end
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def set_activity
    begin
      @activity = Activity.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      flash[:danger] = 'Nie ma aktywności o takim id.'
      redirect_to backend_news_index_path
    end
  end

  def set_zone
    @zone = params[:zone]
  end

  def set_trainers
    @trainers = Trainer.order(:first_name, :last_name)
  end

  def set_person
    @person = current_person
  end

  def set_employees
    @employees = Person.where.not(type: 'Client')
  end

  def set_rule_to_manage
    unless current_manager || current_receptionist
      flash[:danger] = "Brak dostępu. {set_rule_to_manage}"
      redirect_to backend_news_path
    end
  end
end
