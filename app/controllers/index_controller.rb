class IndexController < ApplicationController
  # get /
  def index
    @title    = t('titles.index.index')
    @articles = Article.last(3)
  end
end
