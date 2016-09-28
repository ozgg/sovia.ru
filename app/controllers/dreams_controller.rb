class DreamsController < ApplicationController
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /dreams
  def index
    @collection = Dream.page_for_visitors(current_user, current_page)
  end

  # get /dreams/new
  def new
    @entity = Dream.new
  end

  # post /dreams
  def create
    @entity = Dream.new creation_parameters
    if @entity.save
      redirect_to @entity
    else
      render :new, status: :bad_request
    end
  end

  # get /dreams/:id
  def show
    raise record_not_found unless @entity.visible_to? current_user
  end

  # get /dreams/:id/edit
  def edit
  end

  # patch /dreams/:id
  def update
    if @entity.update entity_parameters
      redirect_to @entity, notice: t('dreams.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /dreams/:id
  def destroy
    if @entity.update(deleted: true)
      flash[:notice] = t('dreams.destroy.success')
    end

    redirect_to dreams_path
  end

  # get /dreams/tagged/:tag_name
  def tagged
    set_tag
    @collection = Dream.tagged(@tag).page_for_visitors(current_user, current_page)
  end

  # get /dreams/archive/(:year)/(:month)
  def archive
    collect_months
    unless params[:month].nil?
      @collection = Dream.archive(params[:year], params[:month]).page_for_visitors current_user, current_page
    end
  end

  private

  def set_entity
    @entity = Dream.find params[:id]
  end

  def restrict_editing
    raise record_not_found unless @entity.editable_by? current_user
  end

  def creation_parameters
    dream_parameters = params.require(:dream).permit(Dream.creation_parameters(current_user))
    dream_parameters.merge(owner_for_entity).merge(tracking_for_entity)
  end

  def entity_parameters
    params.require(:dream).permit(Dream.entity_parameters(@entity.owned_by?(current_user)))
  end

  def set_tag
    @tag = Pattern.find_by! name: params[:tag_name]
  end

  def collect_months
    @dates = Hash.new
    Dream.visible.distinct.pluck("date_trunc('month', created_at)").sort.each do |date|
      @dates[date.year] = [] unless @dates.has_key? date.year
      @dates[date.year] << date.month
    end
  end
end
