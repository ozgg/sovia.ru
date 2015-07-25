class UsersController < ApplicationController
  before_action :restrict_access, except: [:profile, :dreams, :posts, :questions]
  
  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
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
end
