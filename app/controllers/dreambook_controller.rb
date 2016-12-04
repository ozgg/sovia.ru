class DreambookController < ApplicationController
  # get /dreambook
  def index
    letter = params[:letter].to_s.gsub(/[%_]/, '')
    if letter.blank?
      @collection = []
    else
      @collection = Pattern.letter(letter).page_for_visitors(current_page)
    end
  end

  # get /dreambook/:word
  def word
    @entity = Pattern.match_by_name params[:word]
    unless @entity.is_a?(Pattern)
      handle_http_404("Cannot find pattern with word #{params[:word]}")
    end
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
