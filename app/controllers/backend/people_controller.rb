class Backend::PeopleController < BackendController
  helper_method :sort_column, :sort_direction, :sort_bought
  before_action :set_person
  before_action :set_rule_to_edit_client_profile, only: [:edit, :update,
                                                         :destroy, :show]
  # before_action :require_same_user, only: [:show, :bought_history]
  before_action :require_receptionist, only: [:index, :edit, :update, :clients,
                                              :receptionists, :lifeguards,
                                              :trainers]
  before_action :person_exists, only: [:show]
  def search
    if params[:search].present?
      @people = PgSearch.multisearch(params[:search])
                        .paginate(page: params[:page], per_page: 10)
    end
  end

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
    respond_to do |format|
      if @person.update_with_password(person_params)
        sign_in(current_person, bypass: true)
        format.html do
          redirect_to backend_person_path(@person),
                      notice: 'Pomyślnie zaktualizowano.'
        end
      else
        format.html { render :edit }
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
    begin
      @person = Person.find(params[:id]) unless params[:id].blank?
    rescue
      redirect_to root_path
    end
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

  def require_same_person
    unless current_person == @person || current_person.type == 'Manager'
      flash[:danger] = "Możesz edytować tylko własny profil."
      redirect_to backend_person_path(current_person)
    end
  end

  # def require_same_user
  #   unless current_person == @person || current_person.type == 'Manager' ||
  #          current_person.type == 'Receptionist'
  #     flash[:danger] = "Brak dostępu. {require_same_user}"
  #     redirect_to backend_news_index_path
  #   end
  # end

  def require_receptionist
    unless current_person.type == 'Receptionist' ||
           current_person.type == 'Manager' ||
           current_person == @person
      flash[:danger] = "Brak dostępu.{require_receptionist}"
      redirect_to backend_news_index_path
    end
  end

  def set_rule_to_edit_client_profile
    if @person.type == 'Client'
      unless current_person == @person || current_person.type == 'Receptionist' ||
             current_person.type == 'Manager'
        flash[:danger] = "Brak dostępu. {set_rule_to_edit_client_profile}"
        redirect_to backend_news_index_path
      end
    else
      unless current_person == @person || current_person.type == 'Manager'
        flash[:danger] = "Brak dostępu. {set_rule_to_edit_client_profile}"
        redirect_to backend_person_path(current_person)
      end
    end
  end

  def person_exists
    if @person.blank? && curent_person.present?
      flash[:info] = "Brak takiej osoby."
      redirect_to backend_news_index_path
    elsif @person.blank? && current_person.blank?
      flash[:danger] = "Brak dostępu. {person_exists}"
    end
  end
end
