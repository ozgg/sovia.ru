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

  def default_url_options(options = {})
    if I18n.locale == I18n.default_locale
      { locale: nil }.merge options
    else
      { locale: I18n.locale }.merge options
    end
  end

  def visitor_languages
    languages = [Language.find_by(code: I18n.locale).id]
    if current_user.is_a? User
      languages += current_user.user_languages.pluck(:language_id) + [current_user.language_id]
    end
    languages.uniq
  end

  # Wrapper for 'Record not found' exception
  #
  # @return [ActiveRecord::RecordNotFound]
  def record_not_found
    ActiveRecord::RecordNotFound
  end

  def restrict_anonymous_access
    redirect_to login_path, alert: t(:please_log_in) unless current_user.is_a? User
  end

  def require_role(role)
    if current_user.is_a? User
      redirect_to root_path, alert: t(:insufficient_role) unless current_user.has_role? role
    else
      redirect_to login_path, alert: t(:please_log_in)
    end
  end

  def agent
    @agent ||= Agent.for_string(request.user_agent || 'n/a')
  end

  def tracking_for_entity
    { agent: agent, ip: request.env['HTTP_X_REAL_IP'] || request.remote_ip }
  end

  def language_for_entity
    { language: Language.find_by(code: locale) }
  end
end
