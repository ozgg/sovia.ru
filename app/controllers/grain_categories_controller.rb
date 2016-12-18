class GrainCategoriesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /grain_categories/new
  def new
    @entity = GrainCategory.new
  end

  # post /grain_categories
  def create
    @entity = GrainCategory.new entity_parameters
    if @entity.save
      redirect_to admin_grain_category_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /grain_categories/:id/edit
  def edit
  end

  # patch /grain_categories/:id
  def update
    if @entity.update entity_parameters
      redirect_to admin_grain_category_path(@entity), notice: t('grain_categories.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /grain_categories/:id
  def destroy
    if @entity.update deleted: true
      flash[:notice] = t('grain_categories.destroy.success')
    end
    redirect_to admin_grain_categories_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = GrainCategory.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404("Cannot find non-deleted grain category #{params[:id]}")
    end
  end

  def restrict_editing
    if @entity.locked?
      redirect_to admin_grain_category_path(@entity), alert: t('grain_categories.edit.forbidden')
    end
  end

  def entity_parameters
    params.require(:grain_category).permit(GrainCategory.entity_parameters)
  end
end
