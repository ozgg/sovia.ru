class My::GoalsController < ApplicationController
  before_action :allow_authorized_only

  def index
    page   = params[:page] || 1
    @goals = Goal.where(user: current_user).order('id desc').page(page).per(10)
  end
end
