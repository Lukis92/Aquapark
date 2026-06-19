class Backend::NewsController < BackendController
  before_action :set_news, only: [:edit, :update, :show, :destroy, :like]
  before_action :set_visibility, only: :index
  before_action :display_news_rules, only: :show
  before_action :manage_news_rules, only: [:edit, :update, :destroy]
  before_action :creation_news_rules, only: :new
  # GET backend/news
  def index
    @news = @news.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
  end

  # GET backend/news/new
  def new
    @news = News.new
  end

  # POST backend/news
  def create
    @news = News.new(news_params)
    @news.person = current_person
    if @news.save
      redirect_to backend_news_index_path,
                  notice: 'Pomyślnie dodano.'
    else
      render :new
    end
  end

  # GET backend/news/:id/edit
  def edit
  end

  # PATCH/PUT backend/news/1
  def update
    if @news.update(news_params)
      redirect_to backend_news_index_path,
                  notice: 'Pomyślnie zaktualizowano.'
    else
      render :edit
    end
  end

  def like
    like = Like.create(like: params[:like], person: current_person, news: @news)
    if like.valid?
      flash[:notice] = 'Pomyślnie.'
      safe_redirect_back
    else
      flash[:danger] = 'Możesz polubić lub nie tylko raz.'
      safe_redirect_back
    end
  end

  def show
    @comment = Comment.new
  end

  # DELETE backend/news/1
  def destroy
    @news.destroy
    safe_redirect_back notice: 'Pomyślnie usunięto.'
  end

  private

  def set_news
    @news = News.find(params[:id])
  end

  def news_params
    p = params.require(:news).permit(:title, :content, scope: [])
    p.merge(scope: (p[:scope] || []).reject(&:blank?))
  end

  def set_visibility
    if current_manager
      @news = News.where("scope && ARRAY[?]::varchar[]",
                         %w(wszyscy ratownicy trenerzy recepcjoniści klienci))
                  .or(News.where(person_id: current_person))
    elsif current_receptionist
      @news = News.where("scope && ARRAY[?]::varchar[]",
                         %w(wszyscy pracownicy recepcjoniści klienci))
                  .or(News.where(person_id: current_person))
    elsif current_lifeguard
      @news = News.where("scope && ARRAY[?]::varchar[]",
                         %w(wszyscy pracownicy ratownicy))
                  .or(News.where(person_id: current_person))
    elsif current_trainer
      @news = News.where("scope && ARRAY[?]::varchar[]",
                         %w(wszyscy pracownicy trenerzy))
                  .or(News.where(person_id: current_person))
    elsif current_client
      @news = News.where("scope && ARRAY[?]::varchar[]",
                         %w(wszyscy klienci))
                  .or(News.where(person_id: current_person))
    end
  end

  def creation_news_rules
    unless current_manager || current_receptionist
      flash[:danger] = 'Brak dostępu. {creation_news_rules}'
      redirect_to backend_news_index_path
    end
  end

  def manage_news_rules
    unless current_manager || current_person == @news.person
      flash[:danger] = 'Brak dostępu. {manage_news_rules}'
      redirect_to backend_news_index_path
    end
  end

  def display_news_rules
    unless current_manager
      allowed =
        if current_client
          (@news.scope & %w(klienci wszyscy)).any?
        elsif current_receptionist
          (@news.scope & %w(recepcjoniści pracownicy wszyscy)).any?
        elsif current_trainer
          (@news.scope & %w(trenerzy pracownicy wszyscy)).any?
        elsif current_lifeguard
          (@news.scope & %w(ratownicy pracownicy wszyscy)).any?
        end
      unless allowed || @news.person == current_person
        flash[:danger] = 'Brak dostępu. {display_news_rules}'
        redirect_to backend_news_index_path
      end
    end
  end
end
