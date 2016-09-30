class Api::WordsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity

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

  # put /api/words/:id/patterns
  def patterns
    patterns_string = params[:patterns_string]
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    elsif patterns_string.blank?
      render json: { errors: { patterns_string: patterns_string} }, status: :bad_request
    else
      set_new_patterns
    end
  end

  private

  def set_entity
    @entity = Word.find params[:id]
  end

  def restrict_access
    require_role :chief_interpreter, :interpreter
  end

  def set_new_patterns
    @entity.patterns_string = params[:patterns_string]
    update_dreams if @entity.significant?
    render json: { data: { pattern_ids: @entity.pattern_ids, dream_ids: @entity.dream_ids } }
  end

  def update_dreams
    @entity.dreams.each do |dream|
      pattern_ids       = dream.pattern_ids | @entity.pattern_ids
      dream.pattern_ids = pattern_ids
    end
  end
end
