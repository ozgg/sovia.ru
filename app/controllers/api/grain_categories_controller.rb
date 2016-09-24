class Api::GrainCategoriesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:lock, :unlock]

  # put /api/grain_categories/:id/lock
  def lock
    require_role :chief_interpreter
    @entity.update! locked: true

    render json: { data: { locked: @entity.locked? } }
  end

  # delete /api/grain_categories/:id/lock
  def unlock
    require_role :chief_interpreter
    @entity.update! locked: false

    render json: { data: { locked: @entity.locked? } }
  end

  private

  def set_entity
    @entity = GrainCategory.find params[:id]
    raise record_not_found if @entity.deleted?
  end

  def restrict_access
    require_role :administrator
  end
end
