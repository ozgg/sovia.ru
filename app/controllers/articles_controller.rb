class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :check_user_rights, except: [:index, :show, :tagged]

  # get /articles
  def index
    @entries = Entry::Article.recent.page(params[:page] || 1).per(5)
  end

  # get /articles/new
  def new
    @entry = Entry::Article.new
  end

  # post /articles
  def create
    @entry = Entry::Article.new(article_parameters.merge(user: current_user))
    if @entry.save
      flash[:notice] = t('entry.article.created')
      redirect_to verbose_entry_articles_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: 'new'
    end
  end

  # get /articles/:id
  def show
  end

  # get /articles/:id/edit
  def edit
  end

  # patch /articles/:id
  def update
    if @entry.update(article_parameters)
      flash[:notice] = t('entry.article.updated')
      redirect_to verbose_entry_articles_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: 'edit'
    end
  end

  # delete /articles/:id
  def destroy
    if @entry.destroy
      flash[:notice] = t('entry.article.deleted')
    end
    redirect_to entry_articles_path
  end

  # get /articles/tagged/:tag
  def tagged
    @entries = tagged_articles.page(params[:page] || 1).per(5)
  end

  private

  def article_parameters
    params.require(:entry_article).permit(:title, :body, :tags_string)
  end

  def set_article
    @entry = Entry::Article.find(params[:id])
  end

  def tagged_articles
    @tag = Tag::Article.match_by_name(params[:tag])
    raise record_not_found if @tag.nil?

    Entry::Article.recent.joins(:entry_tags).where(entry_tags: { tag: @tag })
  end

  def check_user_rights
    raise UnauthorizedException if current_user.nil? || !current_user.editor?
  end
end
