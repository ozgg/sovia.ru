class UsersController < ApplicationController
  before_action :bounce_authorized, only: [:new, :create]

  # get /users/new
  def new
    @title = t('titles.users.new')
    @user  = User.new
  end

  # post /users
  def create
    if params[:agree]
      after_registration
    else
      create_user
    end
  end

  def recover_form
    @title = t('titles.users.recover_form')
  end

  private

  def bounce_authorized
    unless @current_user.nil?
      flash[:message] = t('session.already_logged_in')
      redirect_to root_path
    end
  end

  def user_parameters
    params.require(:user).permit(:login, :email, :password, :password_confirmation, :allow_mail)
  end

  def create_user
    @user = User.new(user_parameters)
    if @user.save
      session[:user_id] = @user.id
      after_registration
    else
      @title = t('titles.users.new')
      render action: 'new'
    end
  end

  def after_registration
    flash[:message] = t('users.create.successfully')
    redirect_to root_path
  end
end
