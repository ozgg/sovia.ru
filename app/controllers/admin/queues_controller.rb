class Admin::QueuesController < ApplicationController
  before_action { |c| c.demand_role(User::ROLE_EDITOR) }

  def tags
    @tags = Tag::Dream.where(description: nil).order('entries_count desc, canonical_name asc').page(params[:page] || 1).per(20)
  end
end
