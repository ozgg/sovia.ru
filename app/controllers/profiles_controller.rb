class ProfilesController < ApplicationController
  before_action :set_entity

  # get /u/:slug
  def show
  end

  # get /u/slug/:dreams
  def dreams
    @collection = Dream.owned_by(@entity).page_for_visitors(current_user, current_page)
  end

  # get /u/slug/:posts
  def posts
    @collection = Post.owned_by(@entity).page_for_visitors(current_page)
  end

  private

  def set_entity
    @entity = User.with_long_slug(params[:slug])
    raise record_not_found unless @entity.is_a?(User) && !@entity.deleted?
  end
end
