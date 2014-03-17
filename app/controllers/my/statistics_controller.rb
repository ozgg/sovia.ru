class My::StatisticsController < ApplicationController
  before_action :allow_authorized_only

  # get /my/statistics
  def index
    @title = t('controllers.my.statistics.index')
  end

  # get /my/statistics/symbols
  def tags
    where_clause = { :'tags.type' => 'Tag::Dream', user: current_user }

    page   = params[:page] || 1
    @tags  = UserTag.joins(:tag).where(where_clause).order('entries_count desc, tags.name asc').page(page).per(20)
    @title = t('controllers.my.statistics.tags', page: page)
  end
end
