class StatisticsController < ApplicationController
  # get /statistics
  def index
    @title = t('titles.statistics.index')
  end

  # get /statistics/symbols
  def symbols
    page  = params[:page] || 1
    @tags = EntryTag.order('dreams_count desc, canonical_name asc').page(page).per(20)
    @title = t('titles.statistics.symbols', page: page)
  end
end
