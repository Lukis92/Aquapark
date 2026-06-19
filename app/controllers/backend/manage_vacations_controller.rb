class Backend::ManageVacationsController < BackendController
  include Sortable
  helper_method :sort_column
  before_action :select_rule_vacations, only: :index
  def index
    @vacations = Vacation.includes(:person).order(Arel.sql("#{sort_column} #{sort_direction}")).references(:people)
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
