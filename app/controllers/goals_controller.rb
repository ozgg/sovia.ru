class GoalsController < ApplicationController
  before_action :allow_authorized_only, except: [ :index ]
  before_action :set_goal, only: [ :show, :edit, :update, :destroy ]

  # get /goals
  def index
  end

  # get /goals/new
  def new
    @goal = Goal.new
  end

  # post /goals
  def create
    @goal  = Goal.new(goal_parameters.merge(user: current_user))
    if @goal.save
      flash[:notice] = t('goal.created')
      redirect_to my_goals_path
    else
      render action: :new
    end
  end

  # get /goals/:id
  def show
  end

  # get /goals/:id/edit
  def edit
  end

  # patch /goals/:id
  def update
    if @goal.update(goal_parameters)
      flash[:notice] = t('goal.updated')
      redirect_to @goal
    else
      render action: :edit
    end
  end

  # delete /goals/:id
  def destroy
    if @goal.destroy
      flash[:notice] = t('goal.deleted')
    end

    redirect_to my_goals_path
  end

  private

  def goal_parameters
    params.require(:goal).permit(:name, :description, :status)
  end

  def set_goal
    @goal = Goal.find(params[:id])
    raise UnauthorizedException unless @goal.owned_by? current_user
  end
end
