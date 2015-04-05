class DreamsController < ApplicationController
  before_action :set_dream, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /dreams
  def index
    @dreams = allowed_dreams.page(current_page).per(5)
  end

  # get /dreams/:id
  def show
  end

  # get /dreams/new
  def new
    @entry = Entry::Dream.new
  end

  # post /dreams
  def create
    @entry = Entry::Dream.new(dream_parameters.merge(user: current_user))
    if suspect_spam?(current_user, @entry.body, 2)
      emulate_saving
    else
      create_dream
    end
  end

  # get /dreams/:id/edit
  def edit
  end

  # patch /dreams/:id
  def update
    if @entry.update(dream_parameters)
      flash[:notice] = t('dream.updated')
      redirect_to verbose_entry_dreams_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: 'edit'
    end
  end

  # delete /dreams/:id
  def destroy
    if @entry.destroy
      flash[:notice] = t('dream.deleted')
    end
    redirect_to entry_dreams_path
  end

  # get /dreams/tagged/:tag
  def tagged
    @entries = tagged_dreams.page(params[:page] || 1).per(5)
  end

  def random
    @entry = Entry::Dream.random_dream
  end

  def dreams_of_user
    user = User.find_by_login(params[:login])
    raise record_not_found if user.nil?

    @entries = allowed_dreams.where(user: user).page(params[:page] || 1).per(5)
  end

  def archive
    collect_months
    collect_archive unless params[:month].nil?
  end

  private

  def set_dream
    @entry = Entry::Dream.find(params[:id])
    raise UnauthorizedException unless @entry.visible_to? current_user
  end

  def dream_parameters
    parameters = params[:entry_dream].permit(:title, :body, :privacy, :tags_string, :lucidity)
    parameters[:lucidity] = 0 if parameters[:lucidity].to_i < 0
    parameters[:lucidity] = 5 if parameters[:lucidity].to_i > 5
    parameters
  end

  def restrict_editor_access
    raise UnauthorizedException unless @entry.editable_by? current_user
  end

  def allowed_dreams
    maximal_privacy = current_user.nil? ? Entry::PRIVACY_NONE : Entry::PRIVACY_USERS

    Entry::Dream.recent.where("privacy <= #{maximal_privacy}")
  end

  def tagged_dreams
    @tag = Tag::Dream.match_by_name(params[:tag])
    raise record_not_found if @tag.nil?

    allowed_dreams.joins(:entry_tags).where(entry_tags: { tag: @tag })
  end

  def create_dream
    if @entry.save
      flash[:notice] = t('dream.created')
      redirect_to verbose_entry_dreams_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: 'new'
    end
  end

  def emulate_saving
    flash[:notice] = t('dream.created')
    redirect_to entry_dreams_path
  end

  def collect_months
    @dates = {}

    Entry::Dream.uniq.pluck("date_trunc('month', created_at)").sort.each do |date|
      if @dates[date.year].nil?
        @dates[date.year] = []
      end
      @dates[date.year] << date.month
    end
  end

  def collect_archive
    first_day = "%04d-%02d-01 00:00:00" % [params[:year], params[:month]]
    @dreams   = allowed_dreams.where("date_trunc('month', created_at) = '#{first_day}'").page(current_page).per(20)
  end
end
