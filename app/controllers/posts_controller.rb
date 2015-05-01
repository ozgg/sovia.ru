class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :toggle]
  before_action :restrict_anonymous_access, only: [:new, :create, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /posts
  def index
    if current_user && current_user.has_role?(:posts_manager)
      clause = {}
    elsif current_user
      clause = "show_in_list = true or user_id = ?", current_user.id
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

  def toggle
    demand_role :posts_manager
    @post.toggle_visibility!
    render json: { result: @post.show_in_list? }
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
    showing = { show_in_list: current_user.has_role?(:posts_manager) }
    post_parameters.merge(language_for_entity).merge(user: current_user).merge(showing).merge(tracking_for_entity)
  end

  def restrict_editor_access
    raise UnauthorizedException unless @post.editable_by? current_user
  end
end
