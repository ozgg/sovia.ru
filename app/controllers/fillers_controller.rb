class FillersController < ApplicationController
  before_action :allow_editors_only
  before_action :set_filler, only: [:show, :edit, :update, :destroy]

  def index
    @fillers = Filler.order('id asc').page(current_page).per(10)
  end

  def new
    @filler = Filler.new
  end

  def create
    @filler = Filler.new filler_creation
    if @filler.save
      redirect_to @filler
    else
      render :new
    end
  end

  def update
    if @filler.update filler_parameters
      redirect_to @filler
    else
      render :edit
    end
  end

  def destroy
    @filler.destroy
    redirect_to fillers_path
  end

  protected

  def set_filler
    @filler = Filler.find params[:id]
  end

  def filler_parameters
    params.require(:filler).permit(:gender, :queue, :title, :body)
  end

  def filler_creation
    filler_parameters.merge(language_for_entity)
  end
end
