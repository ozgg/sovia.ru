class My::StatisticsController < ApplicationController
  before_action :allow_authorized_only

  # get /my/statistics
  def index
  end

  # get /my/statistics/symbols
  def tags
    where_clause = { :'tags.type' => 'Tag::Dream', user: current_user }

    @tags = UserTag.joins(:tag).where(where_clause).order('entries_count desc, tags.name asc').page(current_page).per(20)
  end
end
