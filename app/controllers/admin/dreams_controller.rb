class Admin::DreamsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/dreams
  def index
    @collection = Dream.page_for_administration current_page
  end

  # get /admin/dreams/:id
  def show
    if @entity.visible_to?(current_user)
      set_adjacent_entities
    else
      handle_http_404("Dream #{params[:id]} is not visible to #{current_user.id}")
    end
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Dream.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404("Cannot find non-deleted dream #{params[:id]}")
    end
  end

  def set_adjacent_entities
    privacy   = Dream.privacy_for_user(current_user)
    @adjacent = {
        prev: Dream.with_privacy(privacy).where('id < ?', @entity.id).order('id desc').first,
        next: Dream.with_privacy(privacy).where('id > ?', @entity.id).order('id asc').first
    }
  end
end
