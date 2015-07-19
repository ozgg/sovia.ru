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
    redirect_to login_path, notice: t(:please_log_in) unless current_user.is_a? User
  end

  def tracking_for_entity
    agent = Agent.for_string(request.user_agent || 'n/a')
    { agent: agent, ip: request.env['HTTP_X_REAL_IP'] || request.remote_ip }
  end

  def language_for_entity
    { language: Language.find_by(code: locale) }
  end
end
