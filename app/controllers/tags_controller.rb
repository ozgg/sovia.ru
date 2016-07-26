class TagsController < ApplicationController
  before_action :restrict_access, except: [:index]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  # get /tags
  def index
    @collection = Tag.page_for_visitors current_page
  end

  # get /tags/new
  def new
    @entity = Tag.new
  end

  # post /tags
  def create
    @entity = Tag.new entity_parameters
    if @entity.save
      redirect_to @entity
    else
      render :new
    end
  end

  # get /tags/:id
  def show
  end

  # get /tags/:id/edit
  def edit
  end

  # patch /tags/:id
  def update
    if @entity.update entity_parameters
      redirect_to @entity, notice: t('tags.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /tags/:id
  def destroy
    if @entity.update! deleted: true
      flash[:notice] = t('tags.destroy.success')
    end
    redirect_to admin_tags_path
  end

  private

  def restrict_access
    require_role :chief_editor, :editor
  end

  def set_entity
    @entity = Tag.find params[:id]
  end

  def entity_parameters
    params.require(:tag).permit(Tag.entity_parameters)
  end
end
