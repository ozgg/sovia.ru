class DreamsController < ApplicationController
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  def index
    selection = Dream.in_languages(visitor_languages).visible_to_user(current_user)
    @collection = selection.order('id desc').page(current_page).per(10)
  end

  def new
    @entity = Dream.new
  end

  def create
    @entity = Dream.new creation_parameters
    if @entity.save
      set_grains
      redirect_to @entity
    else
      render :new
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
    entity_parameters.merge(owner_for_entity).merge(language_for_entity).merge(tracking_for_entity)
  end

  def set_grains
    if @entity.owned_by? current_user
      @entity.grains_string = params.require(:dream).permit(:grains_string).to_s
      @entity.cache_patterns!
    end
  end
end
