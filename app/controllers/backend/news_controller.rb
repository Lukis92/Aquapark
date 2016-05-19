class Backend::NewsController < BackendController
  before_action :set_news, only: [:edit, :update, :show, :destroy, :like]
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
end
