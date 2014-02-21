class DreamsController < ApplicationController
  before_action :set_dream, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /dreams
  def index
    page    = params[:page] || 1
    @title  = "#{t('titles.dreams.index')}, #{t('titles.page')} #{page}"
    @entries = allowed_dreams.page(page).per(5)
  end

  # get /dreams/:id
  def show
    @title = "#{t('titles.dreams.show')} «#{@entry.parsed_title}»"
  end

  # get /dreams/new
  def new
    @title = t('titles.dreams.new')
    @entry = Entry::Dream.new
  end

  # post /dreams
  def create
    @entry = Entry::Dream.new(dream_parameters.merge(user: @current_user))
    if @entry.save
      flash[:notice] = t('entry.dream.created')
      redirect_to @entry
    else
      render action: 'new'
    end
  end

  # get /dreams/:id/edit
  def edit
    @title = t('titles.dreams.edit')
  end

  # patch /dreams/:id
  def update
    if @entry.update(dream_parameters)
      flash[:notice] = t('entry.dream.updated')
      redirect_to @entry
    else
      render action: 'edit'
    end
  end

  # delete /dreams/:id
  def destroy
    if @entry.destroy
      flash[:notice] = t('entry.dream.deleted')
    end
    redirect_to entry_dreams_path
  end

  # get /dreams/tagged/:tag
  def tagged
    page    = params[:page] || 1
    @entries = tagged_dreams.page(page).per(5)
    @title  = "#{t('titles.dreams.tagged')} «#{@tag.name}», #{t('titles.page')} #{page}"
  end

  def random
    @title = t('dreams.random.title')
    @entry = Entry::Dream.random_dream
  end

  def dreams_of_user
    user = User.find_by_login(params[:login])
    page = params[:page] || 1

    @title  = t('titles.dreams.dreams_of_user', login: user.login, page: page)
    @entries = allowed_dreams.where(user: user).page(page).per(5)
  end

  private

  def set_dream
    @entry = Entry::Dream.find(params[:id])
    raise UnauthorizedException unless @entry.visible_to? @current_user
  end

  def dream_parameters
    params[:entry_dream].permit(:title, :body, :privacy, :tags_string)
  end

  def restrict_editor_access
    raise UnauthorizedException unless @entry.editable_by? @current_user
  end

  def allowed_dreams
    maximal_privacy = @current_user.nil? ? Entry::PRIVACY_NONE : Entry::PRIVACY_USERS

    Entry::Dream.recent.where("privacy <= #{maximal_privacy}")
  end

  def tagged_dreams
    @tag = Tag::Dream.match_by_name(params[:tag])
    raise record_not_found if @tag.nil?

    allowed_dreams.joins(:entry_tags).where(entry_tags: { tag: @tag })
  end
end
