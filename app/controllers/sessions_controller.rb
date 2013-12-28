class SessionsController < ApplicationController

  # get /login
  def new
    @title = 'Авторизация'
    unless session[:user_id].nil?
      redirect_authorized_user
    end
  end

  # post /login
  def create
    if session[:user_id].nil?
      authenticate_user
    else
      redirect_authorized_user
    end
  end

  # delete /logout
  def destroy
    if session[:user_id].nil?
      flash[:message] = t('session.not_logged_in')
    else
      session[:user_id] = nil
      flash[:message] = t('session.logged_out')
    end
    redirect_to root_path
  end

  private

  def authenticate_user
    user = User.find_by_login params[:login]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:message] = t('session.logged_in_successfully')
      redirect_to root_path
    else
      redirect_to login_path
      flash[:message] = t('session.invalid_credentials')
    end
  end

  def redirect_authorized_user
    flash[:message] = t('session.already_logged_in')
    redirect_to root_path
  end
end
