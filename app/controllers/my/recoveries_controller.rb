class My::RecoveriesController < ApplicationController
  include Authentication

  before_action :redirect_authenticated_user
  before_action :find_user, only: [:create, :update]

  def show
  end

  def create
    if @user.nil? || @user.email.blank?
      redirect_to my_recovery_path, notice: t('my.recoveries.create.impossible')
    else
      send_code
      redirect_to my_recovery_path, notice: t('my.recoveries.create.completed')
    end
  end

  def update
    find_code
    if @code.nil?
      redirect_to my_recovery_path, notice: t('my.recoveries.update.invalid_code')
    else
      reset_password
    end
  end

  protected

  def find_user
    @user = User.find_by uid: params[:login].to_s.downcase, network: User.networks[:native]
  end

  def find_code
    @code = Code.find_by user: @user, activated: false, category: Code.categories[:recovery]
  end

  def send_code
    code = Code.recovery_for_user @user
    if code.nil?
      logger.warn { "Could not get recovery code for user #{@user.id}" }
    else
      code.track! request.remote_ip, agent
      CodeSender.password(code).deliver_now
    end
  end

  def reset_password
    if @user.update new_user_parameters
      create_token_for_user @user
      @code.update! activated: true
      redirect_to root_path, notice: t('my.recoveries.update.success')
    else
      render :show
    end
  end

  def new_user_parameters
    parameters = params.require(:user).permit(:password)
    parameters[:password] = nil if parameters[:password].blank?
    parameters.merge!(email_confirmed: true) if @code.payload == @user.email
    parameters
  end
end
