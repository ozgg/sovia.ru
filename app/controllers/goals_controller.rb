class GoalsController < ApplicationController
  before_action :restrict_anonymous_access, except: [:index]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @entity = Goal.new
  end

  def create
    @entity = Goal.new creation_parameters
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
      redirect_to @entity, notice: t('goals.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('goals.delete.success')
    end
    redirect_to my_goals_path
  end

  protected

  def set_entity
    @entity = Goal.find_by! id: params[:id], user: current_user
  end

  def entity_parameters
    params.require(:goal).permit(:status, :name, :description)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity).merge(status: Goal.statuses[:issued])
  end
end
