class DreambookController < ApplicationController
  # get /dreambook
  def index
  end

  # get /dreambook/:word
  def word
    @entity = Pattern.match_by_name params[:word]
    raise record_not_found unless @entity.is_a?(Pattern)
  end
end
