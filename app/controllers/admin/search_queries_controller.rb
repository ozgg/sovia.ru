class Admin::SearchQueriesController < ApplicationController
  before_action :restrict_access

  # get /admin/search_queries
  def index
    @collection = SearchQuery.page_for_administration(current_page)
  end

  private

  def restrict_access
    require_role :administrator
  end
end
