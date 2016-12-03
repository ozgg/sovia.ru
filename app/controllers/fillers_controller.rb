class FillersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:edit, :update, :destroy]

  # get /fillers/new
  def new
    @entity = Filler.new
  end

  # post /fillers
  def create
    @entity = Filler.new entity_parameters
    if @entity.save
      redirect_to admin_filler_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /fillers/:id/edit
  def edit
  end

  # patch /fillers/:id
  def update
    if @entity.update entity_parameters
      redirect_to admin_filler_path(@entity), notice: t('fillers.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /fillers/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('fillers.destroy.success')
    end
    redirect_to admin_fillers_path
  end

  protected

  def restrict_access
    require_role :chief_editor, :editor
  end

  def set_entity
    @entity = Filler.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404("Cannot find filler #{params[:id]}")
    end
  end

  def entity_parameters
    params.require(:filler).permit(Filler.entity_parameters)
  end
end
