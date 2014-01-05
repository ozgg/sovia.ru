class IndexController < ApplicationController
  # get /
  def index
    @title    = t('titles.index.index')
    @articles = Post.articles.order('id desc').last(3)
  end
end
