class My::DreamsController < ApplicationController
  before_action :restrict_anonymous_access

  def index
    @collection = current_user.dreams.order('id desc').page(current_page).per(10)
  end

  def tagged
    @grain = Grain.match_by_name! params[:tag_name], Language.find_by(code: locale), current_user
    set_collection_with_grains
  end

  protected

  def set_collection_with_grains
    selection   = Dream.where(user: current_user).joins(:dream_grains).where(dream_grains: { grain: @grain })
    @collection = selection.page(current_page).per(10)
  end
end
