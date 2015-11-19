class StatisticsController < ApplicationController
  def index

  end

  def patterns
    @collection = Pattern.page_for_statistics current_page
  end
end
