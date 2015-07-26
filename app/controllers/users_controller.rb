class UsersController < ApplicationController
  before_action :restrict_access, except: [:profile, :dreams, :posts, :questions]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
    @collection = User.order('network asc, uid asc').page(current_page).per(25)
  end

  def new
    @entity = User.new
  end

  def create
    @entity = User.new creation_parameters
    if @entity.save
      set_roles
      set_languages
      redirect_to @entity, notice: t('users.create.success')
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @entity.update entity_parameters
      set_roles
      set_languages
      redirect_to @entity, notice: t('users.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('users.destroy.success')
    end
    redirect_to users_path
  end

  def profile
  end

  def dreams
  end

  def posts
  end

  def questions
  end

  def comments
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = User.find params[:id]
  end

  def entity_parameters
    permitted = [
        :email, :screen_name, :name, :image, :rating, :gender, :bot, :allow_login, :password, :password_confirmation,
        :email_confirmed, :allow_mail, :language_id
    ]
    parameters = params.require(:user).permit(permitted)
    parameters[:email] = nil if parameters[:email].blank?
    parameters
  end

  def creation_parameters
    parameters = params.require(:user).permit(:network)
    entity_parameters.merge(parameters).merge(tracking_for_entity)
  end

  def set_roles
    @entity.roles = params.require(:user).permit(:roles)
  end

  def set_languages
    @entity.language_ids = params.require(:user).permit(:language_ids)
  end
end
