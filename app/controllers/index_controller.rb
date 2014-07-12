class IndexController < ApplicationController
  # get /
  def index
    @entries = Entry.recent_entries
  end

  # get /sitemap
  def sitemap
    render 'sitemap.xml.erb', layout: false, content_type: 'text/xml'
  end

  # Obsolete actions
  def gone
    render status: :gone
  end
end
