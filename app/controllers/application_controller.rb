class ApplicationController < ActionController::Base

  class UnauthorizedException < Exception
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_user

  protected

  def set_current_user
    @current_user = User.find(session[:user_id]) unless session[:user_id].nil?
  end

  def record_not_found
    ActiveRecord::RecordNotFound
  end
end
