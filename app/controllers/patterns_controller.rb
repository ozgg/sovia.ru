class PatternsController < ApplicationController
  before_action :restrict_editing_access, only: [:new, :create]
  before_action :restrict_management_access, only: [:edit, :update, :destroy]
  before_action :set_pattern, onlt: [:show, :edit, :update, :destroy]

  # get /patterns
  def index
    @patterns = Pattern.suitable_for(current_user).order('code asc').page(current_page).per(25)
  end

  # get /patterns/new
  def new
    @pattern = Pattern.new
  end

  # post /patterns
  def create
    @pattern = Pattern.new creation_parameters
    if @pattern.save
      redirect_to @pattern
    else
      render :new
    end
  end

  # patch /patterns/:id
  def update
    if @pattern.update pattern_parameters
      redirect_to @pattern
    else
      render :edit
    end
  end

  # delete /patterns
  def destroy
    @pattern.destroy
    redirect_to patterns_path
  end

  protected

  def restrict_editing_access
    demand_role :dreambook_editor
  end

  def restrict_management_access
    demand_role :dreambook_manager
  end

  def set_pattern
    @pattern = Pattern.find params[:id]
  end

  def pattern_parameters
    params.require(:pattern).permit(:name, :image, :body)
  end

  def creation_parameters
    pattern_parameters.merge(language_for_entity)
  end
end
