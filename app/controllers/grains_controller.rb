class GrainsController < ApplicationController
  before_action :set_grain, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /grains
  def index
    @entries = allowed_grains.page(params[:page] || 1).per(5)
  end

  # get /grains/:id
  def show
  end

  # get /grains/new
  def new
    @entry = Entry::Grain.new
  end

  # post /grains
  def create
    @entry = Entry::Grain.new(grain_parameters.merge(user: current_user))
    if @entry.save
      flash[:notice] = t('entry.grain.created')
      redirect_to verbose_entry_grains_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: 'new'
    end
  end

  # get /grains/:id/edit
  def edit
  end

  # patch /grains/:id
  def update
    if @entry.update(grain_parameters)
      flash[:notice] = t('entry.grain.updated')
      redirect_to verbose_entry_grains_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: 'edit'
    end
  end

  # delete /grains/:id
  def destroy
    if @entry.destroy
      flash[:notice] = t('entry.grain.deleted')
    end
    redirect_to entry_grains_path
  end

  # get /grains/tagged/:tag
  def tagged
    @entries = tagged_grains.page(params[:page] || 1).per(5)
  end

  def random
    @entry = Entry::Grain.random_grain
  end

  def grains_of_user
    user = User.find_by_login(params[:login])

    @entries = allowed_grains.where(user: user).page(params[:page] || 1).per(5)
  end

  def archive
    collect_months
    collect_archive unless params[:month].nil?
  end

  private

  def set_grain
    @entry = Entry::Grain.find(params[:id])
    raise UnauthorizedException unless @entry.visible_to? current_user
  end

  def grain_parameters
    params[:entry_grain].permit(:title, :body, :privacy, :tags_string)
  end

  def restrict_editor_access
    raise UnauthorizedException unless @entry.editable_by? current_user
  end

  def allowed_grains
    maximal_privacy = current_user.nil? ? Entry::PRIVACY_NONE : Entry::PRIVACY_USERS

    Entry::Grain.recent.where("privacy <= #{maximal_privacy}")
  end

  def tagged_grains
    @tag = Tag::Grain.match_by_name(params[:tag])
    raise record_not_found if @tag.nil?

    allowed_grains.joins(:entry_tags).where(entry_tags: { tag: @tag })
  end

  def collect_months
    @dates = {}

    Entry::Grain.uniq.pluck("date_trunc('month', created_at)").sort.each do |date|
      if @dates[date.year].nil?
        @dates[date.year] = []
      end
      @dates[date.year] << date.month
    end
  end

  def collect_archive
    page      = params[:page] || 1
    first_day = "%04d-%02d-01 00:00:00" % [params[:year], params[:month]]
    @grains   = allowed_grains.where("date_trunc('month', created_at) = '#{first_day}'").page(page).per(20)
  end
end
