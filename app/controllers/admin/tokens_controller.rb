class Admin::TokensController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/tokens
  def index
    @collection = Token.page_for_administration current_page
  end

  # get /admin/tokens/:id
  def show
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Token.find params[:id]
  end
end
