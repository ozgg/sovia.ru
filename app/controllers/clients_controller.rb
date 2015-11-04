class ClientsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
    @collection = Client.page_for_administrator current_page
  end

  def new
    @entity = Client.new
  end

  def create
    @entity = Client.new entity_parameters
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
      redirect_to @entity, notice: t('clients.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('clients.delete.success')
    end
    redirect_to clients_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Client.find params[:id]
  end

  def entity_parameters
    params.require(:client).permit(:name, :secret, :active)
  end
end
