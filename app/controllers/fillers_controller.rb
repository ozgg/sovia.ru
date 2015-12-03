class FillersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
    @collection = Filler.page_for_administrator current_page
  end

  def new
    @entity = Filler.new
  end

  def create
    @entity = Filler.new entity_parameters
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
      redirect_to @entity, notice: t('fillers.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('fillers.delete.success')
    end
    redirect_to fillers_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Filler.find params[:id]
  end

  def entity_parameters
    params.require(:filler).permit(:category, :gender, :title, :body)
  end
end
