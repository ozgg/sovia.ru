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
    @entry = Entry::Post.new
  end

  # post /posts
  def create
    @entry = Post.new(post_parameters.merge(user: current_user))
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
    @entry = Entry::Post.find(params[:id])
    raise UnauthorizedException unless @entry.visible_to? current_user
  end

  def post_parameters
    params.require(:entry_post).permit(:title, :body, :tags_string)
  end

  def restrict_anonymous_access
    raise UnauthorizedException if current_user.nil?
  end

  def restrict_editor_access
    raise UnauthorizedException unless @entry.editable_by? current_user
  end

  def allowed_posts
    maximal_privacy = current_user.nil? ? Entry::PRIVACY_NONE : Entry::PRIVACY_USERS

    Entry::Post.recent.where("privacy <= #{maximal_privacy}")
  end

  def tagged_posts
    @tag = Tag::Post.match_by_name(params[:tag])
    raise record_not_found if @tag.nil?

    allowed_posts.joins(:entry_tags).where(entry_tags: { tag: @tag })
  end

  def emulate_saving
    flash[:notice] = t('entry.post.created')
    redirect_to entry_posts_path
  end

  def create_post
    if @entry.save
      flash[:notice] = t('entry.post.created')
      redirect_to verbose_entry_posts_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: :new
    end
  end
end
