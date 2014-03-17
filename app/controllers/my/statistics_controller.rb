class My::StatisticsController < ApplicationController
  before_action :allow_authorized_only

  # get /my/statistics
  def index
    @title = t('controllers.my.statistics.index')
  end

  # get /my/statistics/symbols
  def tags
    where_clause = { :'user_tags.user_id' => current_user.id }

    page   = params[:page] || 1
    @tags  = Tag::Dream.joins(:user_tags).where(where_clause).order('entries_count desc, tags.name asc').page(page).per(20)
    @title = t('controllers.my.statistics.tags', page: page)
  end
end
