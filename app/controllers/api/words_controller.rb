class Api::WordsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:toggle, :lock, :unlock]

  # post /api/words/:id/toggle
  def toggle
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    else
      render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
    end
  end

  # put /api/words/:id/lock
  def lock
    require_role :chief_interpreter
    @entity.update! locked: true

    render json: { data: { locked: @entity.locked? } }
  end

  # delete /api/words/:id/lock
  def unlock
    require_role :chief_interpreter
    @entity.update! locked: false

    render json: { data: { locked: @entity.locked? } }
  end

  private

  def set_entity
    @entity = Word.find params[:id]
  end

  def restrict_access
    require_role :chief_interpreter, :interpreter
  end
end
