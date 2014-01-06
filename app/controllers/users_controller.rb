class UsersController < ApplicationController
  before_action :bounce_authorized, only: [:new, :create]

  # get /users/new
  def new

  end

  # post /users
  def create

  end

  private

  def bounce_authorized
    unless @current_user.nil?
      flash[:message] = t('session.already_logged_in')
      redirect_to root_path
    end
  end
end
