class BrowsersController < ApplicationController
  before_action :restrict_access

  def index

  end

  def new

  end

  def create

  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Browser.find params[:id]
  end

  def entity_parameters
    params.require(:browser).permit(:name, :mobile, :bot)
  end
end
