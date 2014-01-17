class IndexController < ApplicationController
  # get /
  def index
    @title = t('titles.index.index')
    @posts = Article.recent.first(1)
    @posts += Dream.recent.where(privacy: Dream::PRIVACY_NONE).first(1)
  end
end
