class Api::AgentsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:toggle, :lock, :unlock]

  # post /api/agents/:id/toggle
  def toggle
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    else
      render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
    end
  end

  # put /api/agents/:id/lock
  def lock
    @entity.update! locked: true

    render json: { data: { locked: @entity.locked? } }
  end

  # delete /api/agents/:id/lock
  def unlock
    @entity.update! locked: false

    render json: { data: { locked: @entity.locked? } }
  end

  private

  def set_entity
    @entity = Agent.find_by! id: params[:id], deleted: false
  end

  def restrict_access
    require_role :administrator
  end
end
