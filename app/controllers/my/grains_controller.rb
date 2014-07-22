class My::GrainsController < ApplicationController
  before_action :allow_authorized_only

  def index
    page     = params[:page] || 1
    @entries = Entry::Grain.where(user: current_user).order('id desc').page(page).per(5)
  end
end
