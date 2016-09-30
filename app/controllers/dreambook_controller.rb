class DreambookController < ApplicationController
  # get /dreambook
  def index
  end

  # get /dreambook/:word
  def word
    @entity = Pattern.match_by_name params[:word]
    raise record_not_found unless @entity.is_a?(Pattern)
  end

  # get /dreambook/search
  def search
    @query = param_from_request(:q)[0..100]
    unless @query.blank?
      handler     = WordHandler.new(@query, false)
      @collection = Pattern.where(id: handler.pattern_ids)
      if @collection.count == 1
        redirect_to dreambook_word_path(word: @collection.first.name)
      end
    end
  end
end
