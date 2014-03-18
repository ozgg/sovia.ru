class StatisticsController < ApplicationController
  # get /statistics
  def index
    @title = t('controllers.statistics.index')
  end

  # get /statistics/symbols
  def symbols
    page   = params[:page] || 1
    @tags  = Tag::Dream.order('entries_count desc, canonical_name asc').page(page).per(20)
    @title = t('controllers.statistics.symbols', page: page)
  end
end
