class Api::DreamsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:toggle]

  # post /api/dreams/:id/toggle
  def toggle
    render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
  end

  private

  def set_entity
    @entity = Dream.find params[:id]
    # raise record_not_found unless @entity.editable_by? current_user
  end

  def restrict_access
    require_role :administrator
  end
end
