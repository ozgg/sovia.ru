class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_user

  protected

  def set_current_user
    @current_user = User.find(session[:user_id]) unless session[:user_id].nil?
  end

  def increment_entries_count
    unless @current_user.nil?
      @current_user.increment!(:entries_count)
    end
  end

  def decrement_entries_count
    unless @current_user.nil?
      @current_user.decrement!(:entries_count)
    end
  end
end
