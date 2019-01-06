# frozen_string_literal: true

# Administrative part of legacy patterns management
class Admin::DreambookEntriesController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: :index

  # get /admin/dreambook_entries
  def index
    @collection = DreambookEntry.page_for_administration(current_page)
  end

  # get /admin/dreambook_entries/:id
  def show
  end

  private

  def restrict_access
    require_privilege_group :dreambook_managers
  end

  def set_entity
    @entity = DreambookEntry.find_by(id: params[:id])
    handle_http_404('Cannot find dreambook_entry') if @entity.nil?
  end
end
