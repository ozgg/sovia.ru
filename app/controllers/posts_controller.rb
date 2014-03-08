class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :restrict_anonymous_access, only: [:new, :create, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /posts
  def index
    page   = params[:page] || 1
    @title = "#{t('titles.posts.index')}, #{t('titles.page')} #{page}"
    @entries = allowed_posts.page(page).per(5)
  end

  # get /posts/new
  def new
    @title = t('titles.posts.new')
    @entry = Entry::Post.new
  end

  # post /posts
  def create
    @title = t('titles.posts.new')
    @entry = Entry::Post.new(post_parameters.merge(user: current_user))
    if suspect_spam?(current_user, @entry.body, 2)
      emulate_saving
    else
      create_post
    end
  end

  # get /posts/:id
  def show
    @title = "#{t('titles.posts.show')} «#{@entry.parsed_title}»"
  end

  # get /posts/:id/edit
  def edit
    @title = t('titles.posts.edit')
  end

  # patch /posts/:id
  def update
    @title = t('titles.posts.edit')
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
    redirect_to entry_posts_path
  end

  private

  def set_post
    @entry = Entry::Post.find(params[:id])
    raise UnauthorizedException unless @entry.visible_to? current_user
  end

  def post_parameters
    params.require(:entry_post).permit(:title, :body)
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

  def emulate_saving
    flash[:notice] = t('entry.post.created')
    redirect_to entry_posts_path
  end

  def create_post
    if @entry.save
      flash[:notice] = t('entry.post.created')
      redirect_to @entry
    else
      render action: :new
    end
  end
end
