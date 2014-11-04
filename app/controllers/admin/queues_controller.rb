class Admin::QueuesController < ApplicationController
  before_action { |c| c.demand_role(User::ROLE_EDITOR) }

  def tags
    @tags = tags_in_queue.order('entries_count desc, canonical_name asc').page(params[:page] || 1).per(20)
    total = Tag::Dream.count
    @progress = [total - tags_in_queue.count, total]
  end

  private

  def tags_in_queue
    Tag::Dream.where(description: nil)
  end
end
