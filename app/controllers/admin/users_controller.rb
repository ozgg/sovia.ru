class Admin::UsersController < ApplicationController
  before_action :allow_administrators_only
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # get /admin/users
  def index
    @users = User.order('login asc').page(current_page).per(20)
  end

  # get /admin/users/new
  def new
    @user = User.new
  end

  # post /admin/users
  def create
    @user = User.new(user_parameters)
    if @user.save
      update_roles
      flash[:notice] = t('user.created')
      redirect_to admin_user_path(@user)
    else
      render action: :new
    end
  end

  # get /admin/users/:id
  def show
  end

  # get /admin/users/:id/edit
  def edit
  end

  # patch /admin/users/:id
  def update
    if @user.update user_parameters
      update_roles
      flash[:notice] = t('user.updated')
      # redirect_to admin_user_path(@user)
    else
    end
    render action: :edit
  end

  # delete /admin/users/:id
  def destroy
    redirect_to admin_users_path
  end

  protected

  def set_user
    @user = User.find params[:id]
  end

  def user_parameters
    allowed = [
        :login, :email, :password, :password_confirmation, :allow_mail, :mail_confirmed,
        :avatar, :use_gravatar, :gender, :roles
    ]
    parameters = params.require(:user).permit(allowed)
    parameters[:email] = nil if parameters[:email].blank?

    parameters
  end

  def update_roles
    if params[:user]
      roles = params[:user][:roles] || {}
      @user.roles = roles unless roles.empty?
    end
  end
end
