class IndexController < ApplicationController
  # get /
  def index
    @title = t('titles.index.index')
    @posts = Article.recent.first(1)
    @posts += Dream.recent.where(privacy: Dream::PRIVACY_NONE).first(2)
    @posts += Post.posts.last(1)

    @posts.sort! { |a, b| b.created_at <=> a.created_at }
  end

  # Obsolete actions
  def gone
    @title = t('page_gone')

    render status: :gone
  end
end
