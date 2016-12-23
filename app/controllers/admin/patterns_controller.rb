class Admin::PatternsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/patterns
  def index
    @filter     = params[:filter] || Hash.new
    @collection = Pattern.page_for_administration current_page, @filter
  end

  # get /admin/patterns/:id
  def show
    set_adjacent_entities
  end

  # get /admin/patterns/:id/dreams
  def dreams
    @collection = @entity.dreams.page_for_administration current_page
  end

  private

  def restrict_access
    require_role :chief_interpreter, :interpreter
  end

  def set_entity
    @entity = Pattern.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404("Cannot find non-deleted pattern #{params[:id]}")
    end
  end

  def set_adjacent_entities
    weight    = @entity.dreams_count
    @adjacent = {
        prev: Pattern.where('dreams_count <= ? and id < ?', weight, @entity.id).order('id desc').first,
        next: Pattern.where('dreams_count >= ? and id > ?', weight, @entity.id).order('id asc').first
    }
  end
end
