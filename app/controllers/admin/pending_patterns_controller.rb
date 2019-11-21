# frozen_string_literal: true

# Managing dream patterns queue
class Admin::PendingPatternsController < AdminController
  before_action :set_entity, except: %i[index enqueue]

  # get /admin/pending_patterns
  def index
    @filter = params[:filter]&.permit!.to_h
    @collection = PendingPattern.page_for_administration(current_page, @filter)
  end

  # post /admin/pending_patterns/enqueue
  def enqueue
    list = param_from_request(:list).split(/\r?\n/).reject(&:blank?)
    PendingPattern.enqueue(list) if list.any?

    head :no_content
  end

  # post /admin/pending_patterns/:id/summary
  def summary
    @entity.process!(param_from_request(:summary))

    render json: { meta: { processed: @entity.processed? } }
  end

  private

  def component_slug
    Biovision::Components::DreambookComponent::SLUG
  end

  def set_entity
    @entity = PendingPattern.find_by(id: params[:id])
    handle_http_404('Cannot find pattern') if @entity.nil?
  end
end
