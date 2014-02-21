class MyController < ApplicationController
  before_action :allow_authorized_only

  # get /my
  def index
  end

  # get /my/dreams
  def dreams
    page = params[:page] || 1
    @dreams = Dream.recent.where(user: @current_user).page(page).per(5)
    @title = t('titles.my.dreams', page: page)
  end

  # get /my/profile
  def profile
    @title = t('titles.my.profile')
  end

  # patch /my/profile
  def update_profile
    update_usual_data
    flash[:message] = t('profile.updated')
    update_sensitive_data unless params[:profile][:old_password].blank?
    @current_user.save

    redirect_to my_profile_path
  end

  private


  def update_usual_data
    @current_user.allow_mail = !params[:profile][:allow_mail].blank?
  end

  def update_sensitive_data
    if @current_user.authenticate(params[:profile][:old_password])
      update_email
      update_password
    else
      flash[:message] = t('profile.incorrect_password')
    end
  end

  def update_email
    new_email = params[:profile][:email]
    unless new_email == @current_user.email
      @current_user.email = new_email.blank? ? nil : new_email
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
