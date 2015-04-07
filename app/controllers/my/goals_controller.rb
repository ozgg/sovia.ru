class My::GoalsController < ApplicationController
  before_action :allow_authorized_only

  def index
    @goals = Goal.where(user: current_user).order('id desc').page(current_page).per(10)
  end
end
