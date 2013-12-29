class IndexController < ApplicationController
  # get /
  def index
    @title = t('titles.index.index')
  end
end
