class My::RecoveriesController < ApplicationController
  before_action :allow_unauthorized_only

  def show
  end

  def create
    user   = User.find_by(email: params[:email])
    if user.nil?
      flash[:notice] = t('email_not_found')
      render action: :show
    else
      send_code(user)
      redirect_to my_recovery_path
    end
  end

  def update
    code = Code::Recovery.find_by(body: params[:code], activated: false)
    if code.nil?
      flash[:notice] = t('user.code_invalid')
      redirect_to my_recovery_path
    else
      if code.user.update(new_password)
        if !code.user.email.blank? && (code.payload == code.user.email)
          code.user.update(mail_confirmed: true)
        end

        code.update(activated: true)
        flash[:notice] = t('user.password_changed')
        redirect_to login_path
      else
        flash[:notice] = t('user.recovery_failed')
        redirect_to my_recovery_path
      end
    end
  end

  private

  def allow_unauthorized_only
    unless session[:user_id].nil?
      flash[:notice] = t('session.already_logged_in')
      redirect_to root_path
    end
  end

  def new_password
    params.require(:user).permit(:password, :password_confirmation)
  end

  def send_code(user)
    code = user.password_recovery
    if code.nil?
      flash[:notice] = t('code.generation_error')
    else
      CodeSender.password(code).deliver
      flash[:notice] = t('recovery_code_sent')
    end
  end
end
