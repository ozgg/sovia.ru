class IndexController < ApplicationController
  # get /
  def index
    @entries = Entry.recent_entries
    @posts   = Post.recent_posts(current_user && current_user.has_role?(:posts_manager))

    @recent_tags = Tag::Dream.recently_updated
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
