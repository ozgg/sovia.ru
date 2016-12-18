class TagsController < ApplicationController
  before_action :restrict_access, except: [:index, :show]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

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
      redirect_to admin_tag_path(@entity.id)
    else
      render :new, status: :bad_request
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
      redirect_to admin_tag_path(@entity.id), notice: t('tags.update.success')
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

  def restrict_editing
    if @entity.locked?
      redirect_to admin_tag_path(@entity.id), alert: t('tags.edit.forbidden')
    end
  end

  def set_entity
    @entity = Tag.find_by(id: params[:id], deleted: false)
    if @entity.nil?
      handle_http_404("Cannot find tag #{params[:id]}")
    end
  end

  def entity_parameters
    params.require(:tag).permit(Tag.entity_parameters)
  end
end
