class CommentsController < ApplicationController
  before_action :restrict_access, only: [:index]
  before_action :restrict_anonymous_access, except: [:index, :show, :tagged]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  def index
    @collection = Comment.in_languages(visitor_languages).order('id desc').page(current_page).per(5)
  end

  def new
    @entity = Comment.new
  end

  def create
    @entity = Comment.new creation_parameters
    if @entity.save
      redirect_to @entity.commentable, notice: t('comments.create.success')
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
      redirect_to @entity.commentable, notice: t('comments.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('comments.destroy.success')
    end
    redirect_to comments_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def restrict_editing
    raise UnauthorizedException unless @entity.editable_by? current_user
  end

  def set_entity
    @entity = Comment.find params[:id]
  end

  def entity_parameters
    parameters = params.require(:comment).permit(:commentable_id, :commentable_type, :parent_id, :best, :body)
    unless current_user_has_role? :administrator
      %i(visible best).each { |parameter| parameters.reject! parameter if parameters.include? parameter }
    end
    parameters
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity).merge(language_for_entity).merge(tracking_for_entity)
  end
end
