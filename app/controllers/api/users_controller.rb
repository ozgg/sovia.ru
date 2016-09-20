class Api::UsersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:toggle]

  # post /api/users/:id/toggle
  def toggle
    render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
  end

  private

  def set_entity
    @entity = User.find params[:id]
    raise record_not_found if @entity.deleted?
  end

  def restrict_access
    require_role :administrator
  end
end
