class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :restrict_anonymous_access, only: [:new, :create, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /posts
  def index
    @posts = Post.order('id desc').page(current_page).per(5)
  end

  # get /posts/new
  def new
    @post = Post.new
  end

  # post /posts
  def create
    @post = Post.new(post_parameters.merge(user: current_user))
    @post.language = Language.guess_from_locale
    if @post.save
      flash[:notice] = t('post.created')
      redirect_to @post
    else
      render action: :new
    end
  end

  # get /posts/:id
  def show
  end

  # get /posts/:id/edit
  def edit
  end

  # patch /posts/:id
  def update
    if @post.update(post_parameters)
      flash[:notice] = t('post.updated')
      redirect_to @post
    else
      render action: :edit
    end
  end

  # delete /posts/:id
  def destroy
    @post.destroy
    flash[:notice] = t('post.deleted')
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id].to_i)
  end

  def post_parameters
    params.require(:post).permit(:language_id, :title, :lead, :body, :image)
  end

  def restrict_anonymous_access
    raise UnauthorizedException if current_user.nil?
  end

  def restrict_editor_access
    raise UnauthorizedException unless @post.editable_by? current_user
  end
end
