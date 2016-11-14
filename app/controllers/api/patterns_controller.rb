class Api::PatternsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]
  before_action :restrict_editing, only: [:update, :destroy]

  # get /api/patterns
  def index
    @collection = Pattern.page_for_administration(current_page)
  end

  # get /api/patterns/:id
  def show
  end

  # patch /api/patterns/:id
  def update
    if @entity.update entity_parameters
      set_dependent_entities
      render :show
    else
      render json: { errors: @entity.errors.messages }, status: :bad_request
    end
  end

  # delete /api/patterns/:id
  def destroy
    @entity.destroy
    head :no_content
  end

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

  def restrict_editing
    raise record_not_found if @entity.locked?
  end

  def entity_parameters
    params.require(:pattern).permit(Pattern.entity_parameters)
  end

  def set_dependent_entities
    @entity.words_string = params[:words_string].to_s
  end
end
