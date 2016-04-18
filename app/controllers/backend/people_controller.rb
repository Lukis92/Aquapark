class Backend::PeopleController < BackendController
    before_action :set_person, only: [:edit, :edit_profile, :update, :destroy, :show, :remove_photo, :bought_history]
    # before_action :set_current_person
    helper_method :sort_column, :sort_direction

    def index
        respond_to do |format|
            format.html { @people = Person.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 20) }
            format.json { @people = Person.all }
        end
    end

    def managers
        @managers = Manager.all
      end

    def clients
        respond_to do |format|
            format.html { @clients = Client.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 10) }
            format.json { @clients = Client.all }
        end
    end

    def receptionists
        respond_to do |format|
            format.html { @receptionists = Receptionist.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 10) }
            format.json { @receptionists = Receptionist.all }
        end
    end

    def trainers
        respond_to do |format|
            format.html { @trainers = Trainer.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 10) }
            format.json { @trainers = Trainer.all }
        end
    end

    def lifeguards
        respond_to do |format|
            format.html { @lifequards = Lifeguard.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 10) }
            format.json { @lifequards = Lifeguard.all }
        end
    end

    def update
        respond_to do |format|
            if @person.update_with_password(person_params)
                sign_in(current_person, bypass: true)
                format.html { redirect_to backend_person_path(@person), notice: 'Pomyślnie zaktualizowano.' }
                format.json { render :show_profile, status: :ok, location: @person }
            else
                format.html { render :edit }
                format.json { render json: @person.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @person.destroy
        respond_to do |format|
            format.html { redirect_to :back, notice: 'Pomyślnie usunięto.' }
            format.json { head :no_content }
        end
    end

    def remove_photo
        @person.profile_image.destroy
        @person.update_attributes(profile_image_file_name: nil, profile_image_content_type: nil,
                                  profile_image_file_size: nil, profile_image_updated_at: nil)
        redirect_to backend_person_path(@person), notice: 'Zdjęcie zostało pomyślnie usunięte.'
    end

    def bought_history
      @bought_history = BoughtDetail.where(person_id: @person)
      @last_bought = BoughtDetail.where(person_id: @person).order('bought_data').last
    end

    private

    def person_params
        params.require(:person).permit(:pesel, :first_name, :last_name, :date_of_birth,
                                       :email, :profile_image, :salary, :hiredate, :password, :password_confirmation, :current_password, :remember_me, :roles, :roles_mask)
    end

    def set_person
        @person = Person.find(params[:id])
    end

    def set_current_person
        @current_person = current_person
    end
end
