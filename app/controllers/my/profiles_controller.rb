class My::ProfilesController < ApplicationController
  include Authentication

  before_action :redirect_authorized_user, only: [:new, :create]
  before_action :restrict_anonymous_access, except: [:new, :create]

  # get /my/profile/new
  def new
    @user = User.new
  end

  # post /my/profile
  def create
    if params[:agree]
      redirect_to root_path, notice: t('my.profiles.create.success')
    else
      create_user
    end
  end

  # get /my/profile
  def show
  end

  # get /my/profile/edit
  def edit
  end

  # patch /my/profile
  def update
    if current_user.update user_parameters
      redirect_to my_profile_path, notice: t('my.profiles.update.success')
    else
      render :edit
    end
  end

  protected

  def redirect_authorized_user
    redirect_to my_profile_path if current_user.is_a? User
  end

  def create_user
    @user = User.new creation_parameters
    if @user.save
      create_token_for_user @user, tracking_for_entity
      redirect_to my_profile_path, notice: t('my.profiles.create.success')
    else
      render :new
    end
  end

  def creation_parameters
    parameters = params.require(:user).permit(:screen_name, :email, :password, :password_confirmation)
    parameters.merge(tracking_for_entity).merge(network: User.networks[:native])
  end

  def user_parameters
    sensitive  = sensitive_parameters
    editable   = [:name, :image, :gender] + sensitive
    parameters = params.require(:user).permit(editable)
    filter_parameters parameters, sensitive
  end

  def sensitive_parameters
    if current_user.authenticate params[:password].to_s
      [:password, :password_confirmation, :email]
    else
      []
    end
  end

  def filter_parameters(parameters, sensitive)
    sensitive.each { |parameter| parameters.except! parameter if parameter.blank? }
    parameters[:email_confirmed] = false if parameters[:email] && parameters[:email] != current_user.email
    parameters
  end
end
