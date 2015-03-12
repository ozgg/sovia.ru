class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :restrict_anonymous_access, only: [:new, :create, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /posts
  def index
    @entries = Post.order('id desc').page(params[:page] || 1).per(5)
  end

  # get /posts/new
  def new
    @entry = Post.new
  end

  # post /posts
  def create
    @entry = Post.new(post_parameters.merge(user: current_user))
    @entry.language = Language.guess_from_locale
    if @entry.save
      flash[:notice] = t('entry.post.created')
      redirect_to @entry
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
    if @entry.update(post_parameters)
      flash[:notice] = t('entry.post.updated')
      redirect_to @entry
    else
      render action: :edit
    end
  end

  # delete /posts/:id
  def destroy
    @entry.destroy
    flash[:notice] = t('entry.post.deleted')
    redirect_to posts_path
  end

  private

  def set_post
    @entry = Post.find(params[:id].to_i)
  end

  def post_parameters
    params.require(:post).permit(:language_id, :title, :lead, :body, :image)
  end

  def restrict_anonymous_access
    raise UnauthorizedException if current_user.nil?
  end

  def restrict_editor_access
    raise UnauthorizedException unless @entry.editable_by? current_user
  end
end
