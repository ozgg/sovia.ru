class ViolationsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :destroy]

  def index
    @collection = Violation.order('id desc').page(current_page).per(25)
  end

  def show
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('violations.delete.success')
    end
    redirect_to violations_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Violation.find params[:id]
  end
end
