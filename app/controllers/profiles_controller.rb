class ProfilesController < ApplicationController
  before_action :set_entity

  # get /u/:slug
  def show
  end

  private

  def set_entity
    @entity = User.with_long_slug(params[:slug])
    raise record_not_found unless @entity.is_a?(User) && !@entity.deleted?
  end
end
