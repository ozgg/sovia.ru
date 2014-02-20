class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :check_user_rights, except: [:index, :show]

  # get /articles
  def index
    page     = params[:page] || 1
    @title   = "#{t('titles.articles.index')}, #{t('titles.page')} #{page}"
    @entries = Entry::Article.recent.page(page).per(5)
  end

  # get /articles/new
  def new
    @title = t('titles.articles.new')
    @entry = Entry::Article.new
  end

  # post /articles
  def create
    @entry = Entry::Article.new(article_parameters.merge(user: @current_user))
    if @entry.save
      flash[:notice] = t('entry.article.created')
      redirect_to @entry
    else
      render action: 'new'
    end
  end

  # get /articles/:id
  def show
    @title = "#{t('titles.articles.show')} #{@entry.title}"
  end

  # get /articles/:id/edit
  def edit
    @title = t('titles.articles.edit')
  end

  # patch /articles/:id
  def update
    if @entry.update(article_parameters)
      flash[:notice] = t('entry.article.updated')
      redirect_to @entry
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

  private

  def article_parameters
    params.require(:entry_article).permit(:title, :body)
  end

  def set_article
    @entry = Entry::Article.find(params[:id])
  end

  def check_user_rights
    raise UnauthorizedException if @current_user.nil? || !@current_user.editor?
  end
end
