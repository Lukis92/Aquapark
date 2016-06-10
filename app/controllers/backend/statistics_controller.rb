class Backend::StatisticsController < BackendController
  before_action :require_manager, only: :index
  def index
    @all_people = Person.all.count
    @employees = Person.all.where.not(type: 'Client').count
    @lifeguards = Lifeguard.all.count
    @receptionists = Receptionist.all.count
    @trainers = Trainer.all.count
    @clients = Client.all.count
    @month_registered = Person.all.where('hiredate >= ?', Date.today - 30).count
    @year_registered = Person.all.where('hiredate >= ?', Date.today - 365).count
    @sum_salaries = Person.sum(:salary)
    # @activity_earnings = IndividualTraining.joins(:training_costs).sum(:cost)

    @active_passes = EntryType.joins(:bought_details).where(kind: 'Karnet')
                              .where(['start_on <= ?', Date.today])
                              .where(['end_on >= ?', Date.today]).count
    @active_tickets = EntryType.joins(:bought_details).where(kind: 'Bilet')
                               .where(['start_on <= ?', Date.today])
                               .where(['end_on >= ?', Date.today]).count
    @sum_earnings_tickets = EntryType.joins(:bought_details).where(kind: 'Bilet').sum(:price)
    @sum_earnings_passes = EntryType.joins(:bought_details).where(kind: 'Karnet').sum(:price)
    @sum_earnings_trainings = IndividualTraining.joins(:training_cost).sum(:cost)
    @sum_earnings = EntryType.joins(:bought_details).sum(:price) + @sum_earnings_trainings
    @sum_risk = @sum_earnings + @sum_earnings_trainings - @sum_salaries
    @today_tickets = EntryType.joins(:bought_details).where(kind: 'Bilet')
                              .where(['bought_data = ?', Date.today]).count
    @current_vacations = Vacation.all.where(['start_at <= ?', Date.today])
                                 .where(['end_at >= ?', Date.today]).count
    # Hiredate
    @most_busy = WorkSchedule.group(:person_id)
                             .sum('CAST(extract(epoch from work_schedules.end_time) as integer) - cast(extract(epoch from work_schedules.start_time) as integer)').sort_by { |_, v| 0 - v }.first.first
    @least_busy = WorkSchedule.group(:person_id)
                         .sum('CAST(extract(epoch from work_schedules.end_time) as integer) - cast(extract(epoch from work_schedules.start_time) as integer)').sort_by { |_, v| 0 - v }.last.first

    @most = Person.find(@most_busy)
    @least = Person.find(@least_busy)
    @person_without_work = Person.where.not(type: 'Client').where('id NOT IN (SELECT DISTINCT(person_id) FROM work_schedules)').count
    @earliest_worker = Person.where.not(type: 'Client').order(hiredate: :asc).first
    @last_worker = Person.where.not(type: 'Client').order(hiredate: :desc).first
    @biggest_salary = Person.where.not(type: 'Client').order(salary: :desc).first
    @smallest_salary = Person.where.not(type: 'Client').order(salary: :asc).first
    @avg_salaries = Person.where.not(type: 'Client').average(:salary)
  end

  private

  def require_manager
    unless current_manager
      flash[:danger] = "Brak dostępu"
      redirect_to backend_news_index_path
    end
  end
end
