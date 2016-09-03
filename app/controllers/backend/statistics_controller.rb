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
                             .sum('CAST(extract(epoch from work_schedules.end_time) as integer) - cast(extract(epoch from work_schedules.start_time) as integer)').sort_by { |_, v| v }.last.first
    @least_busy = WorkSchedule.group(:person_id)
                              .sum('CAST(extract(epoch from work_schedules.end_time) as integer) - cast(extract(epoch from work_schedules.start_time) as integer)').sort_by { |_, v| v }.first.first

    @most = Person.find(@most_busy)
    @least = Person.find(@least_busy)
    @person_without_work = Person.where.not(type: 'Client').where('id NOT IN (SELECT DISTINCT(person_id) FROM work_schedules)').count
    @earliest_worker = Person.where.not(type: 'Client').order(hiredate: :asc).first
    @last_worker = Person.where.not(type: 'Client').order(hiredate: :desc).first
    @biggest_salary = Person.where.not(type: 'Client').order(salary: :desc).first
    @smallest_salary = Person.where.not(type: 'Client').order(salary: :asc).first
    @avg_salaries = Person.where.not(type: 'Client').average(:salary)
    @day_most_work = WorkSchedule.group(:day_of_week)
                                 .select('day_of_week, COUNT(id) as work_count')
                                 .order('COUNT(id) DESC').first.day_of_week
    @day_most_work_count = WorkSchedule.where(day_of_week: @day_most_work).count
    @day_least_work = WorkSchedule.group(:day_of_week)
                                  .select('day_of_week, COUNT(id) as work_count')
                                  .order('COUNT(id) ASC').first.day_of_week
    @day_least_work_count = WorkSchedule.where(day_of_week: @day_least_work).count

    # Newsy
    @all_news = News.count
    @client_news = News.where(scope: 'klienci').count
    @receptionist_news = News.where(scope: 'recepcjoniści').count
    @lifeguard_news = News.where(scope: 'ratownicy').count
    @trainer_news = News.where(scope: 'trenerzy').count
    @most_liked_news_id = Like.group(:news_id)
                              .select('news_id, SUM(case when likes.like then 1 else -1 end) as max_positive')
                              .order('max_positive desc').map(&:news_id).first
    @most_liked_news = News.find_by_id(@most_liked_news_id)
    @most_liked_news_likes_count =  Like.where(news_id: @most_liked_news_id).where('likes.like = ?', true).count
    @most_liked_news_dislikes_count = Like.where(news_id: @most_liked_news_id).where('likes.like = ?', false).count

    @most_hated_news_id = Like.group(:news_id)
                           .select('news_id, SUM(case when likes.like then 1 else -1 end) as max_positive')
                           .order('max_positive asc').map(&:news_id).first
    unless @most_hated_news_id.blank?
      @most_hated_news = News.find(@most_hated_news_id)
    end
    @most_hated_news_likes_count =  Like.where(news_id: @most_hated_news_id).where('likes.like = ?', true).count
    @most_hated_news_dislikes_count = Like.where(news_id: @most_hated_news_id).where('likes.like = ?', false).count

    @count_true_likes = Like.where('likes.like = ?', true).group(:news_id).count

    @news_most_comments_id = Comment.group('news_id, comments.id').order('COUNT(id) desc').map(&:news_id).first
    unless @news_most_comments_id.blank?
      @news_most_comments = News.find(@news_most_comments_id).title
    end
  end

  private

  def require_manager
    unless current_manager
      flash[:danger] = 'Brak dostępu'
      redirect_to backend_news_index_path
    end
  end
end
