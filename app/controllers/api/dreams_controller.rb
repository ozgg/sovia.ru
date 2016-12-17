class Api::DreamsController < ApplicationController
  before_action :restrict_access, except: [:interpretation]
  before_action :set_entity

  # post /api/dreams/:id/toggle
  def toggle
    render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
  end

  def interpretation
    if @entity.visible_to?(current_user)
      @patterns = @entity.interpretation
    else
      handle_http_404(t('dreams.not_found.title'))
    end
  end

  private

  def set_entity
    @entity = Dream.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404("Cannot find non-deleted dream #{params[:id]}")
    end
  end

  def restrict_access
    require_role :administrator
  end
end
