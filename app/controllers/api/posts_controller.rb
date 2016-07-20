class Api::PostsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:toggle, :lock, :unlock]

  # post /api/posts/:id/toggle
  def toggle
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    else
      render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
    end
  end

  # put /api/posts/:id/lock
  def lock
    require_role :chief_editor
    @entity.update! locked: true

    render json: { data: { locked: @entity.locked? } }
  end

  # delete /api/posts/:id/lock
  def unlock
    require_role :chief_editor
    @entity.update! locked: false

    render json: { data: { locked: @entity.locked? } }
  end

  private

  def set_entity
    @entity = Post.find_by! id: params[:id], deleted: false
  end

  def restrict_access
    require_role :chief_editor, :editor
  end
end
