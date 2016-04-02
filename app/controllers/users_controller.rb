class UsersController < ApplicationController
  before_action :restrict_access, except: [:profile]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:profile]

  # get /users
  def index
    @filter     = params[:filter] || Hash.new
    @collection = User.page_for_administration current_page, @filter
  end

  # get /users/new
  def new
    @entity = User.new
  end

  # post /users
  def create
    @entity = User.new creation_parameters
    if @entity.save
      set_roles
      redirect_to @entity, notice: t('users.create.success')
    else
      render :new
    end
  end

  # get /users/:id
  def show
  end

  # get /users/:id/edit
  def edit
  end

  # patch /users/:id
  def update
    if @entity.update entity_parameters
      set_roles
      redirect_to @entity, notice: t('users.update.success')
    else
      render :edit
    end
  end

  # delete /users/:id
  def destroy
    if @entity.update(deleted: true)
      flash[:notice] = t('users.destroy.success')
    end
    redirect_to users_path
  end

  # get /u/:slug
  def profile
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = User.find params[:id]
  end

  def set_user
    @user = User.with_long_slug(params[:slug])
    raise record_not_found unless @user.is_a?(User) && !@user.deleted?
  end

  def entity_parameters
    parameters         = params.require(:user).permit(User.entity_parameters)
    parameters[:email] = nil if parameters[:email].blank?
    parameters
  end

  def creation_parameters
    params.require(:user).permit(User.entity_parameters + [:network]).merge(tracking_for_entity)
  end

  def set_roles
    @entity.roles = params[:roles].nil? ? Hash.new : params[:roles]
  end
end
