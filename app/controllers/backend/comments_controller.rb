class Backend::CommentsController < BackendController
  before_action :require_same_user, only: [:edit, :update]
  before_action :set_news
  before_action :set_comment, except: :create
  def create
    @comment = @news.comments.build(comment_params)
    @comment.person = current_person
    if @comment.save
      redirect_to backend_news_path(@news),
                  notice: "Komentarz pomyślnie dodano"
    else
      flash[:danger] = "Komentarz nie został dodany. Wymagana treść, minimum 5 znaków."
      redirect_to :back
    end
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = "Komentarz został zaktualizowany!"
      redirect_to backend_news_path(@news)
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    flash[:notice] = "Komentarz usunięty."
    redirect_to backend_news_path(@news)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_news
    @news = News.find(params[:news_id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie istnieje news o takim id.'
    redirect_to backend_news_index_path
  end

  def set_comment
    @comment = Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = 'Nie istnieje komentarz o takim id.'
    redirect_to backend_news_index_path
  end

  def require_same_user
    begin
      @comment = Comment.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      flash[:danger] = 'Nie istnieje komentarz o takim id.'
      redirect_to backend_news_index_path
    end
    if current_person != @comment.person
      flash[:danger] = "Możesz edytować tylko własne komentarze."
      redirect_to backend_news_index_path
    end
  end
end
