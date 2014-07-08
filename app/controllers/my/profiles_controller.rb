class My::ProfilesController < ApplicationController
  before_action :allow_authorized_only

  def show
  end

  def edit
  end

  def update
    if params[:password].blank?
      update_common_parameters
    else
      if current_user.authenticate(params[:password])
        update_sensitive_parameters
      else
        flash[:notice] = t('profile.incorrect_password')
        render action: :edit
      end
    end
  end

  protected

  def update_common_parameters
    if current_user.update(params.require(:profile).permit(:allow_mail, :avatar))
      flash[:notice] = t('profile.updated')
      redirect_to my_profile_path
    else
      render action: :edit
    end
  end

  def update_sensitive_parameters
    new_parameters = profile_parameters
    if new_parameters[:password].blank?
      new_parameters.except!(:password, :password_confirmation)
    end
    if new_parameters[:email] != current_user.email
      new_parameters[:mail_confirmed] = false
    end

    if current_user.update(new_parameters)
      flash[:notice] = t('profile.updated')
      redirect_to my_profile_path
    else
      flash[:notice] = t('profile.update_error')
      render action: :edit
    end
  end

  def profile_parameters
    params.require(:profile).permit(:allow_mail, :email, :password, :password_confirmation, :avatar)
  end
end
