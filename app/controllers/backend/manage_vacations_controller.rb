class Backend::ManageVacationsController < BackendController
  helper_method :sort_column, :sort_direction
  before_action :select_rule_vacations, only: :index
  def index
    @vacations = Vacation.includes(:person).order(sort_column + ' ' + sort_direction).references(:people)
                         .paginate(page: params[:page], per_page: 20)
  end

  private

  def select_rule_vacations
    unless current_manager || current_receptionist
      redirect_to backend_news_index_path, notice: 'Brak dostępu {select_rule_vacations}'
    end
  end
  JOINED_TABLE_COLUMNS = %w(people.first_name).freeze
  def sort_column
    if JOINED_TABLE_COLUMNS.include?(params[:sort]) || Vacation.column_names.include?(params[:sort])
      params[:sort]
    else
      'start_at'
    end
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
