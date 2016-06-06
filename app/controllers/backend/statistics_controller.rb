class Backend::StatisticsController < BackendController
  before_action :require_manager, only: :index
  def index
    @all_people = Person.all.count
    @employees = Person.all.where.not(type: 'Client').count
    @lifeguards = Lifeguard.all.count
    @recptionists = Receptionist.all.count
    @trainers = Trainer.all.count
    @clients = Client.all.count

    @sum_salaries = Person.sum(:salary)
    @sum_earnings = EntryType.joins(:bought_details).sum(:price)
    @sum_risk = @sum_earnings - @sum_salaries

    @active_passes = EntryType.joins(:bought_details).where(kind: 'Karnet')
                              .where(['start_on <= ?', Date.today])
                              .where(['end_on >= ?', Date.today]).count
    @today_tickets = EntryType.joins(:bought_details).where(kind: 'Bilet')
                              .where(['bought_data = ?', Date.today]).count
    @current_vacations = Vacation.all.where(['start_at <= ?', Date.today])
                                 .where(['end_at >= ?', Date.today]).count
  end

  private

  def require_manager
    unless current_manager
      flash[:danger] = "Brak dostępu"
      redirect_to backend_news_index_path
    end
  end
end
