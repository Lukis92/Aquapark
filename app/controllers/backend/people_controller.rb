class Backend::PeopleController < BackendController
  before_action :set_people, only: [:edit, :update, :show, :remove_photo]

  def index

  end

  def edit

  end


  def update
      if @person.update_with_password(person_params)
        sign_in(current_person, bypass: true)
       redirect_to backend_person_path(@person), notice: 'Pomyślnie zaktualizowano.'
      end
  end

  def remove_photo
    @person.profile_image.destroy
    @person.update_attributes(profile_image_file_name: nil, profile_image_content_type: nil,
    profile_image_file_size: nil, profile_image_updated_at: nil)
    redirect_to backend_person_path(@person), notice: 'Zdjęcie zostało pomyślnie usunięte.'
  end

  private

  def person_params
    params.require(:person).permit(:pesel, :first_name, :last_name, :date_of_birth,
    :email, :profile_image, :salary, :hiredate, :password, :password_confirmation, :current_password)
  end

  def set_people
    @person = Person.find(params[:id])
  end
end
