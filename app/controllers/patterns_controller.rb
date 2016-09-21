class PatternsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /patterns/new
  def new
    @entity = Pattern.new
  end

  # post /patterns
  def create
    @entity = Pattern.new entity_parameters
    if @entity.save
      redirect_to admin_pattern_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /patterns/:id/edit
  def edit
  end

  # patch /patterns/:id
  def update
    if @entity.update entity_parameters
      redirect_to admin_pattern_path(@entity), notice: t('patterns.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /patterns/:id
  def destroy
    if @entity.update deleted: true
      flash[:notice] = t('patterns.destroy.success')
    end
    redirect_to admin_patterns_path
  end

  protected

  def restrict_access
    require_role :chief_interpreter, :interpreter
  end

  def set_entity
    @entity = Pattern.find params[:id]
    raise record_not_found if @entity.deleted?
  end

  def restrict_editing
    if @entity.locked?
      redirect_to admin_pattern_path(@entity), alert: t('patterns.edit.forbidden')
    end
  end

  def entity_parameters
    params.require(:pattern).permit(Pattern.entity_parameters)
  end
end
