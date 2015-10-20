class TagsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
    @collection = Tag.page_for_administrator current_page
  end

  def new
    @entity = Tag.new
  end

  def create
    @entity = Tag.new entity_parameters
    if @entity.save
      redirect_to @entity
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
      redirect_to @entity, notice: t('tags.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('tags.delete.success')
    end
    redirect_to tags_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Tag.find params[:id]
  end

  def entity_parameters
    params.require(:tag).permit(:name)
  end
end
