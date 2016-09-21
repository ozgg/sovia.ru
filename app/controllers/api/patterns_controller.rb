class Api::PatternsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:toggle, :lock, :unlock]

  # post /api/patterns/:id/toggle
  def toggle
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    else
      render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
    end
  end

  # put /api/patterns/:id/lock
  def lock
    require_role :chief_interpreter
    @entity.update! locked: true

    render json: { data: { locked: @entity.locked? } }
  end

  # delete /api/patterns/:id/lock
  def unlock
    require_role :chief_interpreter
    @entity.update! locked: false

    render json: { data: { locked: @entity.locked? } }
  end

  private

  def set_entity
    @entity = Pattern.find params[:id]
    raise record_not_found if @entity.deleted?
  end

  def restrict_access
    require_role :chief_interpreter, :interpreter
  end
end
