class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :restrict_anonymous_access, only: [:new, :create, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /posts
  def index
    page   = params[:page] || 1
    @title = "#{t('titles.posts.index')}, #{t('titles.page')} #{page}"
    @posts = Post.posts.order('id desc').page(page).per(5)
  end

  # get /posts/new
  def new
    @title = t('titles.posts.new')
    @post  = Post.new
  end

  # post /posts
  def create
    @title = t('titles.posts.new')
    @post  = Post.new(post_parameters.merge(user: @current_user))
    if @post.save
      flash[:message] = t('post.added')
      redirect_to @post
    else
      render action: :new
    end
  end

  # get /posts/:id
  def show
    @title = "#{t('titles.posts.show')} «#{@post.parsed_title}»"
  end

  # get /posts/:id/edit
  def edit
    @title = t('titles.posts.edit')
  end

  # patch /posts/:id
  def update
    @title = t('titles.posts.edit')
    if @post.update(post_parameters)
      flash[:message] = t('post.updated')
      redirect_to @post
    else
      render action: :edit
    end
  end

  # delete /posts/:id
  def destroy
    @post.destroy
    flash[:message] = t('post.deleted')
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
    raise record_not_found unless @post.post?
  end

  def post_parameters
    params.require(:post).permit(:title, :body)
  end

  def restrict_anonymous_access
    raise UnauthorizedException if @current_user.nil?
  end

  def restrict_editor_access
    raise UnauthorizedException unless @post.editable_by? @current_user
  end
end
