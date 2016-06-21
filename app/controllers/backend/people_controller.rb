class Backend::PeopleController < BackendController
  helper_method :sort_column, :sort_direction, :sort_bought
  before_action :set_person, except: [:index, :search]
  before_action :set_rule_to_edit_client_profile, only: [:edit, :update,
                                                         :destroy, :show]
  before_action :require_same_user, only: [:show, :bought_history]
  before_action :person_exists, only: :show

  def index
    @people = Person.order(sort_column + ' ' + sort_direction)
                    .paginate(page: params[:page], per_page: 20)
  end

  def clients
    @clients = Client.order(sort_column + ' ' + sort_direction)
                     .paginate(page: params[:page], per_page: 20)
  end

  def receptionists
    @receptionists = Receptionist.order(sort_column + ' ' + sort_direction)
                                 .paginate(page: params[:page],
                                           per_page: 10)
  end

  def lifeguards
    @lifequards = Lifeguard.order(sort_column + ' ' + sort_direction)
                           .paginate(page: params[:page], per_page: 10)
  end

  def trainers
    @trainers = Trainer.order(sort_column + ' ' + sort_direction)
                       .paginate(page: params[:page], per_page: 10)
  end

  def update
    if current_manager && @person != current_manager
      if @person.update(person_params)
        sign_in(current_person, bypass: true)
        redirect_to backend_person_path(@person),
                    notice: 'Pomyślnie zaktualizowano.'
      else
        render :edit
      end
    else
      if @person.update_with_password(person_params)
        sign_in(current_person, bypass: true)
        redirect_to backend_person_path(@person),
                    notice: 'Pomyślnie zaktualizowano.'
      else
        render :edit
      end
    end
  end

  def destroy
    if @person == current_person
      @person.destroy
      redirect_to root_path, notice: 'Pomyślnie usunięto.'
    else
      @person.destroy
      redirect_to :back, notice: 'Pomyślnie usunięto.'
    end
  end

  # GET backend/people/search
  def search
    if params[:query].present? || params[:querydate].present?
      @people = Person.text_search(params[:query], params[:querydate])
                      .paginate(page: params[:page], per_page: 20)
    else
      @people = Person.paginate(page: params[:page], per_page: 20)
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
    @bought_history = BoughtDetail.includes(:entry_type)
                                  .order(sort_bought + ' ' + sort_direction)
                                  .references(:entry_types)
                                  .where(person_id: @person)
                                  .paginate(page: params[:page], per_page: 20)
    @last_bought = BoughtDetail.where(person_id: @person)
                               .order('bought_data').last
  end

  private

  def set_person
    @person = Person.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie ma osoby o takim id.'
    redirect_to backend_news_index_path
  end

  def set_current_person
    @current_person = current_person
  end

  JOINED_TABLE_COLUMNS = %w(entry_types.kind).freeze
  def sort_bought
    if JOINED_TABLE_COLUMNS.include?(params[:sort]) || BoughtDetail.column_names.include?(params[:sort])
      params[:sort]
    else
      'bought_data'
    end
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
                                   :password_confirmation,
                                   :remember_me, activities_people: [:date])
  end

  def require_same_person
    unless current_person == @person || current_manager
      flash[:danger] = "Możesz edytować tylko własny profil."
      redirect_to backend_person_path(current_person)
    end
  end

  def require_same_user
    unless current_person == @person || current_manager || current_receptionist
      flash[:danger] = "Brak dostępu. {require_same_user}"
      redirect_to backend_news_index_path
    end
  end

  def require_receptionist
    unless current_receptionist || current_manager || current_person == @person
      flash[:danger] = "Brak dostępu.{require_receptionist}"
      redirect_to backend_news_index_path
    end
  end

  def set_rule_to_edit_client_profile
    if @person.type == 'Client'
      unless current_person == @person || current_receptionist ||
             current_manager
        flash[:danger] = "Brak dostępu. {set_rule_to_edit_client_profile}"
        redirect_to backend_news_index_path
      end
    else
      unless current_person == @person || current_manager
        flash[:danger] = "Brak dostępu. {set_rule_to_edit_client_profile}"
        redirect_to backend_person_path(current_person)
      end
    end
  end

  def person_exists
    if @person.blank? && curent_person.present?
      flash[:info] = 'Brak takiej osoby.'
      redirect_to backend_news_index_path
    elsif @person.blank? && current_person.blank?
      flash[:danger] = "Brak dostępu. {person_exists}"
    end
  end

  def set_news
    @news = if params[:id].blank?
              News.find(1)
            else
              News.find(params[:id])
            end
  end
end
