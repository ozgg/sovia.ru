# frozen_string_literal: true

# Dreambook for visitors
class DreambookController < ApplicationController
  # get /dreambook
  def index
    @letter = param_from_request(:letter).gsub(/[%_]/, '')
    @collection = @letter.blank? ? [] : Pattern.letter(@letter).list_for_visitors
  end

  # get /dreambook/:word
  def word
    name = params[:word].gsub('-', '_').gsub('+', ' ')
    @entity = Pattern[name]

    handle_http_404("Cannot find pattern #{params[:word]}") if @entity.nil?
  end

  # get /dreambook/search?q=
  def search
    @query = param_from_request(:q)[0..100]
    if @query.blank?
      @collection = []
    else
      log_search_query unless component_handler.allow?
      @collection = Pattern.search(@query).list_for_visitors.first(20)
    end
  end

  private

  def component_slug
    Biovision::Components::DreambookComponent::SLUG
  end

  def log_search_query
    attributes = { body: @query }.merge(owner_for_entity(true))

    DreambookQuery.create(attributes)
  end
end
