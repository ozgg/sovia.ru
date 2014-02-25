class My::ConfirmationsController < ApplicationController
  before_action :allow_authorized_only
  before_action :redirect_without_email
  before_action :redirect_confirmed_user

  def show
  end

  def create
    code = current_user.email_confirmation
    if code.nil?
      flash[:notice] = t('code.generation_error')
      redirect_to my_confirmation_path
    else
      CodeSender.email(code).deliver
      flash[:notice] = t('email_confirmation_sent')
      redirect_to my_confirmation_path
    end
  end

  def update
    code = Code::Confirmation.find_by(user: current_user, body: params[:code], activated: false)
    if code.nil?
      flash[:notice] = t('user.code_invalid')
      redirect_to my_confirmation_path
    else
      use_code(code)
    end
  end

  private

  def redirect_without_email
    if current_user.email.blank?
      flash[:notice] = t('confirmation.set_email')
      redirect_to edit_my_profile_path
    end
  end

  def redirect_confirmed_user
    if current_user.mail_confirmed?
      flash[:notice] = t('user.email_confirmed')
      redirect_to my_profile_path
    end
  end

  def use_code(code)
    if code.payload == current_user.email
      code.update(activated: true)
      current_user.update(mail_confirmed: true)
      flash[:notice] = t('user.email_confirmed')
      redirect_to my_profile_path
    else
      code.update(activated: true)
      flash[:notice] = t('user.code_invalid')
      redirect_to my_confirmation_path
    end
  end
end
