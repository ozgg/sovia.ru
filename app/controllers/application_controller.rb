class ApplicationController < ActionController::Base

  class UnauthorizedException < Exception
  end

  class ForbiddenException < Exception
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) unless session[:user_id].nil?
  end

  protected

  def record_not_found
    ActiveRecord::RecordNotFound
  end

  def allow_authorized_only
    unless current_user
      flash[:notice] = t('please_log_in')
      redirect_to login_path
    end
  end

  def demand_role(role)
    raise UnauthorizedException if current_user.nil? || !current_user.has_role?(role)
  end
end
