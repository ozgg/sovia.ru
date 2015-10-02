class DreamsController < ApplicationController
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  def index
    @collection = visible_dreams.order('id desc').page(current_page).per(10)
  end

  def new
    @entity = Dream.new
  end

  def create
    @entity = Dream.new creation_parameters
    if Trap.suspect_spam?(current_user, @entity.body.to_s, 1)
      emulate_saving
    else
      create_dream
    end
  end

  def show
  end

  def edit
  end

  def update
    if @entity.update entity_parameters
      set_grains
      redirect_to @entity, notice: t('dreams.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('dreams.destroy.success')
    end
    redirect_to dreams_path
  end

  def tagged
    @pattern = Pattern.match_by_name params[:tag_name]
    raise record_not_found unless @pattern.is_a? Pattern
    set_collection_with_pattern
  end

  def archive
    @dates = {}
    collect_months
    collect_archive unless params[:month].nil?
  end

  protected

  def restrict_editing
    raise UnauthorizedException unless @entity.editable_by? current_user
  end

  def set_entity
    @entity = Dream.find params[:id].to_i
    raise record_not_found unless @entity.visible_to? current_user
  end

  def entity_parameters
    permitted = Dream.parameters_for_all
    permitted += Dream.parameters_for_users if current_user
    permitted += Dream.parameters_for_administrators if current_user_has_role? :administrator
    params.require(:dream).permit(permitted)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity).merge(tracking_for_entity)
  end

  def set_grains
    if @entity.owned_by? current_user
      @entity.grains_string = params.require(:dream).permit(:grains_string).to_s
      @entity.cache_patterns!
    end
  end

  def visible_dreams
    Dream.visible_to_user(current_user)
  end

  def set_collection_with_pattern
    patterns_clause = { pattern: @pattern, status: DreamPattern.visible_statuses }
    selection       = Dream.visible_to_user(current_user).joins(:dream_patterns).where(dream_patterns: patterns_clause)

    @collection = selection.page(current_page).per(10)
  end

  def collect_months
    Dream.uniq.pluck("date_trunc('month', created_at)").sort.each do |date|
      @dates[date.year] = [] unless @dates.has_key? date.year
      @dates[date.year] << date.month
    end
  end

  def collect_archive
    first_day   = '%04d-%02d-01 00:00:00' % [params[:year], params[:month]]
    @collection = visible_dreams.where("date_trunc('month', created_at) = '#{first_day}'").page(current_page).per(20)
  end

  def create_dream
    @entity.privacy = Dream.privacies[:generally_accessible] if current_user.nil?
    if @entity.save
      set_grains
      redirect_to @entity, notice: t('dreams.create.success')
    else
      render :new
    end
  end

  def emulate_saving
    parameters = { user: @entity.user, category: Violation.categories[:dreams_spam], body: @entity.body }
    Violation.create(parameters.merge tracking_for_entity)

    redirect_to dreams_path, notice: t('dreams.create.success')
  end
end
