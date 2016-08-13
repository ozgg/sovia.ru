class Api::AgentsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /api/agents
  def index
    filter = params[:filter] || Hash.new
    @collection = Agent.page_for_administration current_page, filter
  end

  # patch /api/agents/:id
  def update
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    else
      if @entity.update(entity_parameters)
        render :show
      else
        render json: { errors: @entity.errors }, status: :bad_request
      end
    end
  end

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

  def entity_parameters
    params.require(:agent).permit(Agent.entity_parameters)
  end

  def restrict_access
    require_role :administrator
  end
end
