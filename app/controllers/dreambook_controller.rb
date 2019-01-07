# frozen_string_literal: true

# Public part of legacy dreambook
class DreambookController < ApplicationController
  # get /dreambook
  def index
    letter      = params[:letter].to_s.gsub(/[%_]/, '')
    @collection = letter.blank? ? [] : DreambookEntry.letter(letter).page_for_visitors(current_page)
  end

  # get /dreambook/:word
  def word
    @entity = DreambookEntry.match_by_name params[:word].tr('-', '_').tr('+', ' ')
    if @entity.nil?
      handle_http_404("Cannot find dreambook entry with word #{params[:word]}")
    end
  end

  # get /dreambook/search
  def search
  end

  private

  def log_search_query
    SearchQuery.create({ body: @query }.merge(owner_for_entity(true)))
  end
end
