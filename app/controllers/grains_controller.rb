class GrainsController < ApplicationController
  before_action :set_grain, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /grains
  def index
  end

  # get /grains/:id
  def show
  end

  # get /grains/new
  def new
    @entry = Entry::Grain.new
  end

  # post /grains
  def create
    @entry = Entry::Grain.new(grain_parameters.merge(user: current_user))
    if @entry.save
      flash[:notice] = t('entry.grain.created')
      redirect_to verbose_entry_grains_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: 'new'
    end
  end

  # get /grains/:id/edit
  def edit
  end

  # patch /grains/:id
  def update
    if @entry.update(grain_parameters)
      flash[:notice] = t('entry.grain.updated')
      redirect_to verbose_entry_grains_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: 'edit'
    end
  end

  # delete /grains/:id
  def destroy
    if @entry.destroy
      flash[:notice] = t('entry.grain.deleted')
    end
    redirect_to entry_grains_path
  end

  private

  def set_grain
    @entry = Entry::Grain.find(params[:id])
    raise UnauthorizedException unless @entry.visible_to? current_user
  end

  def grain_parameters
    params[:entry_grain].permit(:title, :body, :privacy, :tags_string)
  end

  def restrict_editor_access
    raise UnauthorizedException unless @entry.editable_by? current_user
  end
end
