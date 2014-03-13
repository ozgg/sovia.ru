class UsersController < ApplicationController
  before_action :bounce_authorized, only: [:new, :create, :recover_form, :recover ]

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

  # get /users/recover-form
  def recover_form
    @title = t('titles.users.recover_form')
  end

  # post /users/recover
  def send_recovery
    user = User.find_by(email: params[:email].to_s.downcase)
    if user.nil?
      flash[:notice] = t('email_not_found')
      redirect_to recover_form_users_path
    else
      send_recovery_code user
      redirect_to recover_users_path
    end
  end

  # get /users/recover
  def recover
    @title = t('titles.users.recover')
  end

  # post /users/confirm
  def send_confirmation
    code = current_user.email_confirmation
    unless code.nil?
      CodeSender.email(code).deliver
      flash[:notice] = t('email_confirmation_sent')
    end

    redirect_to confirm_users_path
  end

  # get /users/confirm
  def confirm
    @title = t('titles.users.confirm')
  end

  # post /users/code
  def code
    given_code = Code.find_by(body: params[:code], activated: false)
    if given_code.nil?
      flash[:notice] = t('user.code_invalid')
      render action: params.has_key?(:user) ? :recover : :confirm
    else
      if given_code.password_recovery?
        recover_password(given_code)
      else
        confirm_email(given_code)
      end
    end
  end

  private

  def bounce_authorized
    unless current_user.nil?
      flash[:notice] = t('session.already_logged_in')
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
    flash[:notice] = t('users.create.successfully')
    redirect_to root_path
  end

  def send_recovery_code(user)
    code = user.password_recovery
    if code.nil?
      flash[:notice] = t('recovery_code_failure')
    else
      CodeSender.password(code).deliver
      flash[:notice] = t('recovery_code_sent')
    end
  end

  def recover_password(code)
    if code.user.update(recovered_password_parameters)
      flash[:notice] = t('user.password_changed')
      code.update(activated: true)
      redirect_to root_path
    else
      flash[:notice] = t('user.recovery_failed')
      render action: :recover
    end
  end

  def confirm_email(code)
    code.user.update(mail_confirmed: true)
    code.update(activated: true)
    flash[:notice] = t('user.email_confirmed')
    redirect_to root_path
  end

  def recovered_password_parameters
    params.require(:user).permit(:password, :password_confirmation).merge(mail_confirmed: true)
  end
end
