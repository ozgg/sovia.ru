class MyController < ApplicationController
  before_action :allow_authorized_only

  # get /my
  def index
    @title = t('titles.my.index')
  end

  # get /my/dreams
  def dreams
    page = params[:page] || 1
    @dreams = Dream.recent.where(user: @current_user).page(page).per(5)
    @title = t('titles.my.dreams', page: page)
  end

  # get /my/profile
  def profile

  end

  # patch /my/profile
  def update_profile
    @current_user.update(usual_parameters)
    flash[:message] = t('profile.updated')
    update_sensitive_data if params[:profile][:old_password]

    redirect_to my_profile_path
  end

  private

  def allow_authorized_only
    unless @current_user
      flash[:message] = t('please_log_in')
      redirect_to login_path
    end
  end

  def update_sensitive_data
    if @current_user.authenticate(params[:profile][:old_password])
      update_email
      update_password
      @current_user.save
    else
      flash[:message] = t('profile.incorrect_password')
    end
  end

  def usual_parameters
    params.require(:profile).permit(:allow_mail)
  end

  def update_email
    unless params[:profile][:email].empty?
      @current_user.email = params[:profile][:email]
      @current_user.mail_confirmed = false
    end
  end

  def update_password
    unless params[:profile][:password].empty?
      @current_user.password = params[:profile][:password]
      @current_user.password_confirmation = params[:profile][:password_confirmation]
    end
  end
end
