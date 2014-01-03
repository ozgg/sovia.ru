class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :check_user_rights, except: [:index, :show]

  # get /articles
  def index
    page      = params[:page] || 1
    @title    = "#{t('titles.articles.index')}, #{t('titles.page')} #{page}"
    @articles = Article.order('id desc').page(page).per(5)
  end

  # get /articles/new
  def new
    @title   = t('titles.articles.new')
    @article = Article.new
  end

  # post /articles
  def create
    @article = Article.new(article_parameters.merge({ user_id: session[:user_id] }))
    if @article.save
      increment_entries_count
      flash[:message] = t('article.added')
      redirect_to article_path(@article)
    else
      render action: 'new'
    end
  end

  # get /articles/:id
  def show
    @title = "#{t('titles.articles.show')} #{@article.title}"
  end

  # get /articles/:id/edit
  def edit
    @title = t('titles.articles.edit')
  end

  # patch /articles/:id
  def update
    if @article.update(article_parameters)
      flash[:message] = t('article.updated')
      redirect_to article_path(@article)
    else
      render action: 'edit'
    end
  end

  # delete /articles/:id
  def destroy
    if @article.destroy
      flash[:message] = t('article.deleted')
      decrement_entries_count
    end
    redirect_to articles_path
  end

  private

  def article_parameters
    params.require(:article).permit(:title, :body)
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def check_user_rights
    redirect_to(root_path) if session[:user_id].nil?
  end
end
