class UsersController < ApplicationController
  before_action :bounce_authorized, only: [:new, :create ]

  # get /users/new
  def new
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

  # get /u/:login
  def profile
    find_user_by_login params[:login]
  end

  def posts
    find_user_by_login params[:login]
    max_privacy = current_user.nil? ? Entry::PRIVACY_NONE : Entry::PRIVACY_USERS
    @entries = Entry::Article.where(user_id: @user.id).where("privacy <= #{max_privacy}").order('id desc').page(params[:page] || 1).per(5)
  end

  private

  def bounce_authorized
    unless current_user.nil?
      flash[:notice] = t('session.already_logged_in')
      redirect_to root_path
    end
  end

  def user_parameters
    parameters = params.require(:user).permit(:login, :email, :password, :password_confirmation, :allow_mail)
    parameters[:email] = nil if parameters[:email].blank?
    parameters
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
    flash[:notice] = t('users.create.successfully')
    redirect_to root_path
  end

  def find_user_by_login(login)
    @user = User.find_by(login: login)
    raise record_not_found if @user.nil?
  end
end
