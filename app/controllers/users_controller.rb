class UsersController < ApplicationController
  before_action :bounce_authorized, only: [:new, :create]

  # get /users/new
  def new
    @title = t('titles.users.new')
    @user  = User.new
  end

  # post /users
  def create
    @user = User.new(user_parameters)
    if @user.save
      session[:user_id] = @user.id
      flash[:message]   = t('users.create.successfully')
      redirect_to root_path
    else
      @title = t('titles.users.new')
      render action: 'new'
    end
  end

  private

  def bounce_authorized
    unless @current_user.nil?
      flash[:message] = t('session.already_logged_in')
      redirect_to root_path
    end
  end

  def user_parameters
    params.require(:user).permit(:login, :email, :password, :password_confirmation)
  end
end
