class My::ProfilesController < ApplicationController
  before_action :allow_authorized_only

  # get /my/profile
  def show
  end

  # get /my/profile/edit
  def edit
  end

  # patch /my/profile
  def update
    if params[:password].blank?
      update_common_parameters
    else
      if current_user.authenticate(params[:password])
        update_sensitive_parameters
      else
        flash[:notice] = t('profile.incorrect_password')
        render :edit
      end
    end
  end

  protected

  def update_common_parameters
    if current_user.update(common_parameters)
      current_user.language_ids = params[:user][:language_ids] || []
      flash[:notice] = t('profile.updated')
      redirect_to my_profile_path
    else
      render :edit
    end
  end

  def common_parameters
    new_parameters = params.require(:profile).permit(:allow_mail, :avatar, :use_gravatar, :gender, :language_id)
    new_parameters[:allow_mail] = false if new_parameters[:allow_mail].nil?
    new_parameters[:use_gravatar] = false if new_parameters[:use_gravatar].nil?
    new_parameters[:gender] = nil if new_parameters[:gender].blank?
    new_parameters[:language_id] = nil unless Language.find_by id: new_parameters[:language_id]

    new_parameters
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
    params.require(:profile).permit(:allow_mail, :email, :password, :password_confirmation, :avatar, :use_gravatar)
  end
end
