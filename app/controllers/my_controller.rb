class MyController < ApplicationController
  before_action :allow_authorized_only

  # get /my
  def index
  end

  # get /my/dreams
  def dreams
    page = params[:page] || 1
    @dreams = Dream.recent.where(user: @current_user).page(page).per(5)
  end

  private

  def allow_authorized_only
    unless @current_user
      flash[:message] = t('please_log_in')
      redirect_to login_path
    end
  end
end
