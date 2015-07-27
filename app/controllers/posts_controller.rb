class PostsController < ApplicationController
  before_action :restrict_anonymous_access, except: [:index, :show, :tagged]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

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

  def tagged

  end

  protected

  def restrict_editing
    raise UnauthorizedException unless @post.editable_by? current_user
  end

  def set_entity
    @entity = Post.find params[:id]
  end

  def entity_parameters
    parameters = params.require(:post).permit(:show_in_list, :title, :image, :lead, :body)
    parameters.reject!(:show_in_list) unless current_user_has_role? :administrator
    parameters
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity).merge(language_for_entity).merge(tracking_for_entity)
  end

  def set_tags
    @entity.tags_string = params.require(:post).permit(:tags_string)
  end
end
