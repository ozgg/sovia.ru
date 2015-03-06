class StatisticsController < ApplicationController
  # get /statistics
  def index
  end

  # get /statistics/symbols
  def symbols
    page   = params[:page] || 1
    @tags  = Tag::Dream.where('entries_count > 0').order('entries_count desc, canonical_name asc').page(page).per(20)
  end
end
