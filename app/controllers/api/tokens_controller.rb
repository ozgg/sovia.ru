class Api::TokensController < ApplicationController
  before_action :restrict_access, except: [:toggle]
  before_action :set_entity, only: [:toggle]
  before_action :restrict_editing, only: [:toggle]

  # post /api/tokens/:id/toggle
  def toggle
    render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
  end

  private

  def set_entity
    @entity = Token.find params[:id]
  end

  def restrict_editing
    raise record_not_found unless @entity.editable_by?(current_user)
  end

  def restrict_access
    require_role :administrator
  end
end
