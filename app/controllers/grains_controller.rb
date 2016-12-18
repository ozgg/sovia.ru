class GrainsController < ApplicationController
  before_action :restrict_anonymous_access
  before_action :set_entity, except: [:new, :create]

  # get /grains/new
  def new
    @entity = Grain.new
  end

  # post /grains
  def create
    @entity = Grain.new creation_parameters
    if @entity.save
      redirect_to my_grain_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /grains/:id/edit
  def edit
  end

  # patch /grains/:id
  def update
    if @entity.update entity_parameters
      redirect_to my_grain_path(@entity), notice: t('grains.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /grains/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('grains.destroy.success')
    end

    redirect_to my_grains_path
  end

  private

  def set_entity
    @entity = Grain.owned_by(current_user).find_by(id: params[:id])
    if @entity.nil?
      error = "Cannot find grain #{params[:id]} owned by #{current_user.id}"
      handle_http_404(error)
    end
  end

  def entity_parameters
    params.require(:grain).permit(Grain.entity_parameters)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity)
  end
end
