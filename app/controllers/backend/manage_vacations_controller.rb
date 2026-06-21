class Backend::ManageVacationsController < BackendController
  include Sortable
  helper_method :sort_column
  before_action :select_rule_vacations, only: :index

  def index
    @employees = Person.where.not(type: 'Client').order(:first_name, :last_name)
    scope = Vacation.includes(:person).references(:people)
    scope = scope.where(person_id: params[:person_id]) if params[:person_id].present?
    scope = scope.where('start_at >= ?', params[:date_from]) if params[:date_from].present?
    scope = scope.where('start_at <= ?', params[:date_to])   if params[:date_to].present?
    scope = scope.where(accepted: params[:accepted] == 'true') if params[:accepted].present?
    @vacations = scope.order(Arel.sql("#{sort_column} #{sort_direction}"))
                      .paginate(page: params[:page], per_page: 20)
  end

  private

  def select_rule_vacations
    unless current_manager || current_receptionist
      redirect_to backend_news_index_path, notice: 'Brak dostępu {select_rule_vacations}'
    end
  end

  def sort_column
    sortable_column(Vacation, default: 'start_at', joined: %w(people.first_name))
  end
end
