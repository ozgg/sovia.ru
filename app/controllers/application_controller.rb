class ApplicationController < ActionController::Base
  class UnauthorizedException < Exception
  end

  class ForbiddenException < Exception
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_page, :current_user

  # Get current page from request
  #
  # @return [Integer]
  def current_page
    @current_page ||= (params[:page] || 1).to_s.to_i.abs
  end

  def current_user
    @current_user ||= Token.user_by_token cookies['token']
  end

  protected

  # Wrapper for 'Record not found' exception
  #
  # @return [ActiveRecord::RecordNotFound]
  def record_not_found
    ActiveRecord::RecordNotFound
  end

  def restrict_anonymous_access
    redirect_to root_path, notice: t(:please_log_in) unless current_user.is_a? User
  end
end
