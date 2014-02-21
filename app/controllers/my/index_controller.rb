class My::IndexController < ApplicationController
  def index
    @title = t('titles.my.index')
  end
end
