class Backend::PeopleController < BackendController
  helper_method :sort_column, :sort_direction, :sort_bought
  before_action :set_person, only: [:edit, :edit_profile, :update, :destroy,
                                    :show, :remove_photo, :bought_history]
  # before_action :set_current_person

  def search
    if params[:search].present?
      @people = PgSearch.multisearch(params[:search])
                        .paginate(page: params[:page], per_page: 10)
    end
  end

  def index
    respond_to do |format|
      format.html do
        @people = Person.order(sort_column + ' ' + sort_direction)
                        .paginate(page: params[:page], per_page: 20)
      end
      format.json { @people = Person.all }
    end
  end

  def managers
    @managers = Manager.all
  end

  def clients
    respond_to do |format|
      format.html do
        @clients = Client.order(sort_column + ' ' + sort_direction)
                         .paginate(page: params[:page], per_page: 10)
      end
      format.json { @clients = Client.all }
    end
  end

  def receptionists
    respond_to do |format|
      format.html do
        @receptionists = Receptionist.order(sort_column + ' ' + sort_direction)
                                     .paginate(page: params[:page],
                                               per_page: 10)
      end
      format.json { @receptionists = Receptionist.all }
    end
  end

  def trainers
    respond_to do |format|
      format.html do
        @trainers = Trainer.order(sort_column + ' ' + sort_direction)
                           .paginate(page: params[:page], per_page: 10)
      end
      format.json { @trainers = Trainer.all }
    end
  end

  def lifeguards
    respond_to do |format|
      format.html do
        @lifequards = Lifeguard.order(sort_column + ' ' + sort_direction)
                               .paginate(page: params[:page], per_page: 10)
      end
      format.json { @lifequards = Lifeguard.all }
    end
  end

  def update
    respond_to do |format|
      if @person.update_with_password(person_params)
        sign_in(current_person, bypass: true)
        format.html do
          redirect_to backend_person_path(@person),
                      notice: 'Pomyślnie zaktualizowano.'
        end
        format.json { render :show_profile, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json do
          render json: @person.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @person.destroy
    respond_to do |format|
      format.html do
        redirect_to backend_clients_path,
                    notice: 'Pomyślnie usunięto.'
      end
      format.json { head :no_content }
    end
  end

  def remove_photo
    @person.profile_image.destroy
    @person.update_attributes(profile_image_file_name: nil,
                              profile_image_content_type: nil,
                              profile_image_file_size: nil,
                              profile_image_updated_at: nil)
    redirect_to backend_person_path(@person),
                notice: 'Zdjęcie zostało pomyślnie usunięte.'
  end

  def bought_history
    @bought_history = BoughtDetail.order(sort_bought + ' ' + sort_direction)
                                  .where(person_id: @person)
                                  .paginate(page: params[:page], per_page: 20)
    @last_bought = BoughtDetail.where(person_id: @person)
                               .order('bought_data').last
  end

  private

  def set_person
    @person = Person.find(params[:id]) unless params[:id].blank?
  end

  def set_current_person
    @current_person = current_person
  end

  def sort_bought
    BoughtDetail.column_names.include?(params[:sort]) ? params[:sort] : 'end_on'
  end

  def sort_column
    Person.column_names.include?(params[:sort]) ? params[:sort] : 'first_name'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def person_params
    params.require(:person).permit(:pesel, :first_name, :last_name,
                                   :date_of_birth, :email, :profile_image,
                                   :salary, :hiredate, :password,
                                   :password_confirmation, :current_password,
                                   :remember_me, :roles, :roles_mask)
  end
end
