class IndexController < ApplicationController
  # get /
  def index
    @title = t('titles.index.index')
    @posts = Entry.recent_entries
  end

  # Obsolete actions
  def gone
    @title = t('page_gone')

    render status: :gone
  end
end
