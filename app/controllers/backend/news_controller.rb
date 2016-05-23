class Backend::NewsController < BackendController
  before_action :set_news, only: [:edit, :update, :show, :destroy, :like]
  before_action :set_visibility, only: [:index]
  before_action :set_rule_to_display_news, only: [:show]
  # GET backend/news
  def index
    @news = @news.paginate(page: params[:page], per_page: 5)
  end

  # GET backend/news/new
  def new
    @news = News.new
  end

  # POST backend/news
  def create
    @news = News.new(news_params)
    @news.person = Person.find(current_person)
    respond_to do |format|
      if @news.save
        format.html do
          redirect_to backend_news_index_path,
                      notice: 'Pomyślnie dodano.'
        end
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT backend/news/1
  def update
    respond_to do |format|
      if @news.update(news_params)
        format.html do
          redirect_to backend_news_index_path,
                      notice: 'Pomyślnie zaktualizowano.'
        end
      else
        format.html { render :edit }
      end
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
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Pomyślnie usunięto.' }
    end
  end

  private

  def set_news
    @news = News.find(params[:id])
  end

  def news_params
    params.require(:news).permit(:title, :content, :scope)
  end

  def set_visibility
    if current_person.type == 'Manager'
      @news = News.where(scope: %w(wszyscy ratownicy trenerzy
                                   recepcjoniści klienci))
    elsif current_person.type == 'Receptionist'
      @news = News.where(scope: %w(recepcjonisci klienci))
    elsif current_person.type == 'Lifeguard'
      @news = News.where(scope: 'ratownicy')
    elsif current_person.type == 'Trainer'
      @news = News.where(scope: 'trenerzy')
    elsif current_person.type == 'Client'
      @news = News.where(scope: 'klienci')
    end
  end

  def set_rule_to_display_news
    unless current_person.type == 'Manager'
      unless @news.scope == 'klienci' && (current_person.type == 'Client' ||
                                          current_person.type == 'Receptionist')
        flash[:danger] = "Brak dostępu."
        redirect_to backend_news_index_path(@news)
      end

      unless @news.scope == 'trenerzy' && (current_person.type == 'Trainer')
        flash[:danger] = "Brak dostępu."
        redirect_to backend_news_index_path(@news)
      end

      unless @news.scope == 'ratownicy' && (current_person.type == 'Lifeguard')
        flash[:danger] = "Brak dostępu."
        redirect_to backend_news_index_path(@news)
      end

      unless @news.scope == 'recepcjoniści' && (current_person.type == 'Receptionist')
        flash[:danger] = "Brak dostępu."
        redirect_to backend_news_index_path(@news)
      end
    end
  end
end
