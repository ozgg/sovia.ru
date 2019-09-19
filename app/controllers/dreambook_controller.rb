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

  private

  def component_slug
    Biovision::Components::DreambookComponent::SLUG
  end
end
