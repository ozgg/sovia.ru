class IndexController < ApplicationController
  # get /
  def index
    @title    = t('titles.index.index')
    @articles = Article.recent.first(3)
  end
end
