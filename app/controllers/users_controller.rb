class UsersController < ApplicationController
  before_action :restrict_access, except: [:profile, :dreams, :posts, :questions]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:profile, :posts, :dreams, :questions, :comments, :patterns]

  def index
    @filter = params[:filter] || Hash.new
    @collection = User.page_for_administrator current_page, @filter
  end

  def new
    @entity = User.new
  end

  def create
    @entity = User.new creation_parameters
    if @entity.save
      set_roles
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
    @dreams = Dream.owned_by(@user).visible_to_user(current_user, @user).order('id desc').page(current_page).per(5)
  end

  def posts
    @posts = @user.posts.recent(current_user_has_role? :administrator).page(current_page).per(5)
  end

  def questions
    @questions = @user.questions.recent.page(current_page).per(5)
  end

  def comments
    @comments = @user.comments.recent.page(current_page).per(20)
  end

  def patterns
    @patterns = @user.patterns.by_slug.page(current_page).per(25)
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = User.find params[:id]
  end

  def set_user
    @user = User.with_long_uid(params[:uid])
    raise record_not_found unless @user.is_a? User
  end

  def entity_parameters
    permitted = [
        :email, :screen_name, :name, :image, :rating, :gender, :bot, :allow_login, :password, :password_confirmation,
        :email_confirmed, :allow_mail
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
    @entity.roles = params[:roles].nil? ? Hash.new : params[:roles]
  end
end
