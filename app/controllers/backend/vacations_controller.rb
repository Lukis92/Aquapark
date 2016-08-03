class Backend::VacationsController < BackendController
  before_action :set_vacation, only: [:edit, :show, :update, :accept, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :set_person, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_employees
  before_action :select_rule_own_vacations, only: [:list, :new, :edit, :update, :destroy]
  # before_action :select_rule_vacations, only: :index
  # GET backend/vacations
  def index
    @vacations = Vacation.order(sort_column + ' ' + sort_direction)
                         .paginate(page: params[:page], per_page: 20)
    @old_vacations = Vacation.where(person_id: @person.id)
                             .where(['end_at < ?', Date.today])
                             .paginate(page: params[:page], per_page: 20)
    @current_vacation = Vacation.where(person_id: @person.id)
                                .where(['start_at <= ?', Date.today])
                                .where(['end_at >= ?', Date.today])
                                .where(['accepted = ?', true]).first
    @unapproved_vacations = Vacation.where(person_id: @person.id)
                                    .where('accepted = ?', false)
                                    .paginate(page: params[:page], per_page: 20)
    @all_vacations = Vacation.all
    @nearest_un_vacations = Vacation.where(person_id: @person.id)
                                    .where(['start_at >= ?', Date.today])
                                    .where(['accepted = ?', false])
                                    .order(:start_at)
                                    .paginate(page: params[:page], per_page: 20)
    @nearest_vacations = Vacation.where(person_id: @person.id)
                                 .where('start_at >= ?', Date.today)
                                 .where('accepted = ?', true).order(:start_at)
                                 .paginate(page: params[:page], per_page: 20)
    @nearest_vacation = @nearest_vacations.first unless @nearest_vacations.nil?
    @days = 0
    # count days to end of current vacation
    unless @current_vacation.blank?
      @end_vacation = (@current_vacation.end_at - Date.today).to_i
    end

    unless @current_vacation.blank?
      @vac_days = (@current_vacation.end_at - @current_vacation.start_at).to_i
    end

    unless @nearest_vacation.blank?
      @days = (@nearest_vacation.start_at - Date.today).to_i
    end
  end

  # GET backend/vacations/new
  def new
    @vacation = Vacation.new
  end

  def edit
  end

  # POST backend/vacations
  def create
    @vacation = Vacation.new(vacation_params)
    if @vacation.save
      redirect_to backend_vacations_path(@person), notice: 'Pomyślnie dodano.'
    else
      render :new
    end
  end

  # PATCH/PUT backend/vacations/1
  def update
    if @vacation.update(vacation_params)
      redirect_to backend_vacations_path(@person), notice: 'Pomyślnie zaktualizowano.'
    else
      render :edit
    end
  end

  # DELETE backend/vacations/1
  def destroy
    @vacation.destroy
    redirect_to :back, notice: 'Pomyślnie usunięto.'
  end

  def search
    if params[:query].present? || params[:querydate].present?
      @vacations = Vacation.text_search(params[:query], params[:querydate])
                           .paginate(page: params[:page],
                                     per_page: 20)
    else
      @vacations = Vacation.paginate(page: params[:page], per_page: 20)
    end
  end

  def requests
    @un_vacations = Vacation.where(accepted: :false)
                            .paginate(page: params[:page], per_page: 20)
  end

  def accept
    begin
      @vacation.update!(accepted: true)
    rescue ActiveRecord::RecordInvalid => invalid
      puts invalid.record.errors
    end
    if @vacation.valid?
      redirect_to :back, notice: 'Zaakceptowano.'
    else
      redirect_to :back, danger: 'Coś poszło nie tak.'
    end
  end

  private

  def vacation_params
    params.require(:vacation)
          .permit(:start_at, :end_at, :free, :reason, :person_id, :accepted)
  end

  def sort_column
    Vacation.column_names.include?(params[:sort]) ? params[:sort] : 'start_at'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def set_vacation
    @vacation = Vacation.find(params[:vacation_id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie ma urlopu o takim id.'
    redirect_to backend_news_index_path
  end

  def set_person
    @person = Person.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie ma osoby o takim id.'
    redirect_to backend_news_index_path
  end

  def set_employees
    @employees = Person.where.not(type: 'Client').order(:first_name, :last_name)
  end

  def manage_rule_vacations
    unless current_manager || current_receptionist
      flash[:danger] = 'Brak dostępu {manage_rule_vacations}'
      redirect_to backend_news_index_path
    end
  end

  def select_rule_own_vacations
    unless current_manager || current_receptionist || current_person == @person
      flash[:danger] = 'Brak dostępu {select_rule_own_vacations}'
      redirect_to backend_news_index_path
    end
  end
end
