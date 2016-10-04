class Api::QuestionsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:lock, :unlock]

  # put /api/questions/:id/lock
  def lock
    @entity.update! locked: true

    render json: { data: { locked: @entity.locked? } }
  end

  # delete /api/questions/:id/lock
  def unlock
    @entity.update! locked: false

    render json: { data: { locked: @entity.locked? } }
  end

  private

  def set_entity
    @entity = Question.find_by! id: params[:id], deleted: false
  end

  def restrict_access
    require_role :administrator
  end
end
