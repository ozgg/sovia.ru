class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :restrict_anonymous_access, only: [:new, :create, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /posts
  def index
    if current_user && current_user.has_role?(:posts_manager)
      clause = {}
    else
      clause = { show_in_list: true }
    end
    @posts = Post.where(clause).order('id desc').page(current_page).per(10)
  end

  # get /posts/new
  def new
    @post = Post.new
  end

  # post /posts
  def create
    @post = Post.new creation_parameters
    if @post.save
      flash[:notice] = t('post.created')
      redirect_to @post
    else
      render :new
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
      render :edit
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
    allowed = [:title, :lead, :body, :image]
    allowed << :show_in_list if current_user.has_role? :posts_manager
    params.require(:post).permit(allowed)
  end

  def creation_parameters
    show_in_list = current_user.has_role?(:posts_manager)
    post_parameters.merge(language_for_entity).merge(user: current_user).merge(show_in_list: show_in_list)
  end

  def restrict_anonymous_access
    raise UnauthorizedException if current_user.nil?
  end

  def restrict_editor_access
    raise UnauthorizedException unless @post.editable_by? current_user
  end
end
