class Backend::StatisticsController < BackendController
  before_action :require_manager, only: :index
  def index
    # Osoby — jedno GROUP BY zamiast 6 osobnych COUNT
    counts_by_type = Person.group(:type).count
    @all_people = counts_by_type.values.sum
    @clients = counts_by_type['Client'].to_i
    @lifeguards = counts_by_type['Lifeguard'].to_i
    @receptionists = counts_by_type['Receptionist'].to_i
    @trainers = counts_by_type['Trainer'].to_i
    @employees = @all_people - @clients
    @month_registered = Person.where('hiredate >= ?', Date.today - 30).count
    @year_registered = Person.where('hiredate >= ?', Date.today - 365).count
    @sum_salaries = Person.sum(:salary)

    # Wejściówki — dwa GROUP BY zamiast 6 osobnych zapytań
    active_entry_counts = BoughtDetail.joins(:entry_type)
                                      .where('bought_details.start_on <= ?', Date.today)
                                      .where('bought_details.end_on >= ?', Date.today)
                                      .group('entry_types.kind').count
    @active_passes = active_entry_counts['Karnet'].to_i
    @active_tickets = active_entry_counts['Bilet'].to_i

    earnings_by_kind = EntryType.joins(:bought_details).group(:kind).sum(:price)
    @sum_earnings_tickets = earnings_by_kind['Bilet'].to_f
    @sum_earnings_passes = earnings_by_kind['Karnet'].to_f
    @sum_earnings_trainings = IndividualTraining.joins(:training_cost).sum(:cost)
    @sum_earnings = earnings_by_kind.values.sum.to_f + @sum_earnings_trainings
    @sum_risk = @sum_earnings + @sum_earnings_trainings - @sum_salaries

    @today_tickets = BoughtDetail.joins(:entry_type).where(entry_types: { kind: 'Bilet' })
                                 .where(bought_data: Date.today).count
    @current_vacations = Vacation.where('start_at <= ? AND end_at >= ?', Date.today, Date.today).count

    # Harmonogram pracy — jeden GROUP BY zamiast 4 zapytań
    work_hours_sql = Arel.sql('CAST(extract(epoch from work_schedules.end_time) as integer) - cast(extract(epoch from work_schedules.start_time) as integer)')
    sorted_busy = WorkSchedule.group(:person_id).sum(work_hours_sql).sort_by { |_, v| v }
    @most_busy  = sorted_busy.last&.first
    @least_busy = sorted_busy.first&.first
    @most  = Person.find(@most_busy)  if @most_busy
    @least = Person.find(@least_busy) if @least_busy

    employees_scope = Person.where.not(type: 'Client')
    @person_without_work = employees_scope.where('id NOT IN (SELECT DISTINCT(person_id) FROM work_schedules)').count
    @earliest_worker = employees_scope.order(hiredate: :asc).first
    @last_worker     = employees_scope.order(hiredate: :desc).first
    @biggest_salary  = employees_scope.order(salary: :desc).first
    @smallest_salary = employees_scope.order(salary: :asc).first
    @avg_salaries    = employees_scope.average(:salary)

    day_counts = WorkSchedule.group(:day_of_week).count.sort_by { |_, v| v }
    if day_counts.any?
      @day_least_work, @day_least_work_count = day_counts.first
      @day_most_work,  @day_most_work_count  = day_counts.last
    end

    # Newsy
    @all_news = News.count
    @client_news      = News.where("scope @> ARRAY[?]::varchar[]", 'klienci').count
    @receptionist_news = News.where("scope @> ARRAY[?]::varchar[]", 'recepcjoniści').count
    @lifeguard_news   = News.where("scope @> ARRAY[?]::varchar[]", 'ratownicy').count
    @trainer_news     = News.where("scope @> ARRAY[?]::varchar[]", 'trenerzy').count

    likes_score_sql = 'news_id, SUM(case when likes.like then 1 else -1 end) as score'
    scored_likes = Like.group(:news_id).select(likes_score_sql)
    @most_liked_news_id  = scored_likes.order('score desc').map(&:news_id).first
    @most_hated_news_id  = scored_likes.order('score asc').map(&:news_id).first

    @most_liked_news = News.find_by(id: @most_liked_news_id)
    @most_hated_news = News.find_by(id: @most_hated_news_id)

    likes_counts = Like.where(news_id: [@most_liked_news_id, @most_hated_news_id])
                       .group(:news_id, :like).count
    @most_liked_news_likes_count    = likes_counts[[@most_liked_news_id, true]].to_i
    @most_liked_news_dislikes_count = likes_counts[[@most_liked_news_id, false]].to_i
    @most_hated_news_likes_count    = likes_counts[[@most_hated_news_id, true]].to_i
    @most_hated_news_dislikes_count = likes_counts[[@most_hated_news_id, false]].to_i

    @count_true_likes = Like.where('likes.like = ?', true).group(:news_id).count
    @news_most_comments_id = Comment.group(:news_id).order('COUNT(id) desc').pick(:news_id)
    @news_most_comments = News.find(@news_most_comments_id).title unless @news_most_comments_id.blank?
  end

  private

  def require_manager
    unless current_manager
      flash[:danger] = 'Brak dostępu'
      redirect_to backend_news_index_path
    end
  end
end
