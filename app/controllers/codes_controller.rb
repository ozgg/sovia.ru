class CodesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
    @collection = Code.page_for_administration current_page
  end

  def new
    @entity = Code.new
  end

  def create
    @entity = Code.new creation_parameters
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
      redirect_to @entity, notice: t('codes.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('codes.delete.success')
    end
    redirect_to codes_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Code.find params[:id]
  end

  def entity_parameters
    params.require(:code).permit(:body, :payload)
  end

  def creation_parameters
    parameters = params.require(:code).permit(:user_id, :category)
    entity_parameters.merge(parameters)
  end
end
