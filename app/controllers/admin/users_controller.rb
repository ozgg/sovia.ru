class Admin::UsersController < ApplicationController
  before_action :allow_administrators_only
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # get /admin/users
  def index
    @users = User.order('login asc').page(params[:page] || 1).per(20)
  end

  # get /admin/users/new
  def new
    @user = User.new
  end

  # post /admin/users
  def create

  end

  # get /admin/users/:id
  def show
  end

  # get /admin/users/:id/edit
  def edit
  end

  # patch /admin/users/:id
  def update

  end

  # delete /admin/users/:id
  def destroy

  end

  protected

  def set_user
    @user = User.find params[:id]
  end

  def user_parameters
    params.require(:user).permit(:login, :email, :password, :password_confirmation, :allow_mail, :avatar, :roles)
  end
end
