class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :restrict_anonymous_access, only: [:new, :create, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /posts
  def index
    page     = params[:page] || 1
    @entries = allowed_posts.page(page).per(5)
    @title   = t('controllers.posts.index', page: page)
  end

  # get /posts/new
  def new
    @entry = Entry::Post.new
    @title = t('controllers.posts.new')
  end

  # post /posts
  def create
    @title = t('controllers.posts.new')
    @entry = Entry::Post.new(post_parameters.merge(user: current_user))
    if suspect_spam?(current_user, @entry.body, 2)
      emulate_saving
    else
      create_post
    end
  end

  # get /posts/:id
  def show
    @title = t('controllers.posts.show', title: @entry.parsed_title)
  end

  # get /posts/:id/edit
  def edit
    @title = t('controllers.posts.edit')
  end

  # patch /posts/:id
  def update
    @title = t('controllers.posts.edit')
    if @entry.update(post_parameters)
      flash[:notice] = t('entry.post.updated')
      redirect_to verbose_entry_posts_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: :edit
    end
  end

  # delete /posts/:id
  def destroy
    @entry.destroy
    flash[:notice] = t('entry.post.deleted')
    redirect_to entry_posts_path
  end

  # get /posts/tagged/:tag
  def tagged
    page     = params[:page] || 1
    @entries = tagged_posts.page(page).per(5)
    @title   = t('controllers.posts.tagged', tag: @tag.name, page: page)
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
