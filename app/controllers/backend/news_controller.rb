class Backend::NewsController < BackendController
  before_action :set_news, only: [:edit, :update, :show, :destroy, :like]
  before_action :set_visibility, only: :index
  before_action :display_news_rules, only: :show
  before_action :manage_news_rules, only: [:edit, :update, :destroy]
  before_action :creation_news_rules, only: :new
  # GET backend/news
  def index
    @news = News.paginate(page: params[:page], per_page: 5)
  end

  # GET backend/news/new
  def new
    @news = News.new
  end

  # POST backend/news
  def create
    @news = News.new(news_params)
    @news.person = Person.find(current_person)
    if @news.save
      redirect_to backend_news_index_path,
                  notice: 'Pomyślnie dodano.'
    else
      render :new
    end
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
      flash[:notice] = "Pomyślnie."
      redirect_to :back
    else
      flash[:danger] = "Możesz polubić lub nie tylko raz."
      redirect_to :back
    end
  end

  def show
    @comment = Comment.new
  end

  # DELETE backend/news/1
  def destroy
    @news.destroy
    redirect_to :back, notice: 'Pomyślnie usunięto.'
  end

  private

  def set_news
    @news = News.find(params[:id])
  end

  def news_params
    params.require(:news).permit(:title, :content, :scope)
  end

  def set_visibility
    if current_manager
      @news = News.where(scope: %w(wszyscy ratownicy trenerzy
                                   recepcjoniści klienci))
    elsif current_receptionist
      @news = News.where(scope: %w(recepcjonisci klienci))
    elsif current_lifeguard
      @news = News.where(scope: 'ratownicy')
    elsif current_trainer
      @news = News.where(scope: 'trenerzy')
    elsif current_client
      @news = News.where(scope: 'klienci')
    end
  end

  def creation_news_rules
    if current_client
      flash[:danger] = "Brak dostępu. {creation_news_rules}"
      redirect_to backend_news_index_path
    end
  end

  def manage_news_rules
    unless current_manager || current_person == @news.person
      flash[:danger] = "Brak dostępu. {manage_news_rules}"
      redirect_to backend_news_index_path
    end
  end

  def display_news_rules
    unless current_manager
      if current_client
        unless @news.scope == 'klienci'
          flash[:danger] = "Brak dostępu. {display_news_rules}"
          redirect_to backend_news_index_path
        end
      elsif current_receptionist
        unless @news.scope == 'recepcjonisci'
          flash[:danger] = "Brak dostępu. {display_news_rules}"
          redirect_to backend_news_index_path
        end
      elsif current_trainer
        unless @news.scope == 'trenerzy'
          flash[:danger] = "Brak dostępu. {display_news_rules}"
          redirect_to backend_news_index_path
        end
      elsif current_lifeguard
        unless @news.scope == 'ratownicy'
          flash[:danger] = "Brak dostępu. {display_news_rules}"
          redirect_to backend_news_index_path
        end
      end
    end
  end
end
