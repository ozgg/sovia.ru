class My::RecoveriesController < ApplicationController
  before_action :redirect_authenticated_user
  before_action :find_user, only: [:create]

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

  end

  protected

  def redirect_authenticated_user
    redirect_to root_path, notice: t(:already_logged_in) unless current_user.nil?
  end

  def find_user
    @user = User.find_by uid: params[:login].to_s.downcase, network: User.networks[:native]
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
end
