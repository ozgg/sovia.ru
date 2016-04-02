class TokensController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
    @collection = Token.page_for_administration current_page
  end

  def new
    @entity = Token.new
  end

  def create
    @entity = Token.new creation_parameters
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
      redirect_to @entity, notice: t('tokens.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('tokens.delete.success')
    end
    redirect_to tokens_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Token.find params[:id]
  end

  def entity_parameters
    params.require(:token).permit(:active)
  end

  def creation_parameters
    parameters = params.require(:token).permit(Token.entity_parameters)
    entity_parameters.merge(parameters).merge(tracking_for_entity)
  end
end
