class DreamsController < ApplicationController
  before_action :set_dream, only: [:show]

  # get /dreams
  def index
    page = params[:page] || 1
    @dreams = Dream.order('id desc').page(page).per(5)
  end

  # get /dreams/:id
  def show

  end

  private

  def set_dream
    @dream = Dream.find(params[:id])
  end
end
