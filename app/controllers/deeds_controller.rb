class DeedsController < ApplicationController
  before_action :allow_authorized_only, except: [ :index ]
  before_action :set_deed, only: [ :show, :edit, :update, :destroy ]

  # get /deeds
  def index
    @title = t('controllers.deeds.index')
  end

  # get /deeds/new
  def new
    @deed  = Deed.new
  end

  # post /deeds
  def create
    @deed  = Deed.new(deed_parameters.merge(user: current_user))
    if @deed.save
      flash[:notice] = t('deed.created')
      redirect_to my_deeds_path
    else
      render action: :new
    end
  end

  # get /deeds/:id
  def show
    @title = t('controllers.deeds.show', deed: @deed.name)
  end

  # get /deeds/:id/edit
  def edit
    @title = t('controllers.deeds.edit')
  end

  # patch /deeds/:id
  def update
    @title = t('controllers.deeds.edit')
    if @deed.update(deed_parameters)
      flash[:notice] = t('deed.updated')
      redirect_to @deed
    else
      render action: :edit
    end
  end

  # delete /deeds/:id
  def destroy
    if @deed.destroy
      flash[:notice] = t('deed.deleted')
    end

    redirect_to my_deeds_path
  end

  private

  def deed_parameters
    params.require(:deed).permit(:name)
  end

  def set_deed
    @deed = Deed.find(params[:id])
    raise UnauthorizedException unless @deed.user == current_user
  end
end
