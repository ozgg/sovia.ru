class My::ProfilesController < ApplicationController
  before_action :redirect_authorized_user, only: [:new, :create]
  before_action :restrict_anonymous_access, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    if params[:agree]
      redirect_to root_path, notice: t('profiles.create.success')
    else
      create_user
    end
  end

  def show
  end

  def edit
  end

  def update

  end

  protected

  def redirect_authorized_user
    redirect_to my_profile_path if current_user.is_a? User
  end

  def create_user
    @user = User.new creation_parameters
    if @user.save
      set_token
      redirect_to my_profile_path
    else
      render :new
    end
  end

  def set_token
    token_parameters = { user: @user }.merge(tracking_for_entity)
    token = Token.create! token_parameters
    cookies['token'] = token.cookie_pair
  end

  def creation_parameters
    parameters = params.require(:user).permit(:screen_name, :email, :password, :password_confirmation)
    parameters.merge(tracking_for_entity).merge(language_for_entity).merge(network: User.networks[:native])
  end
end
