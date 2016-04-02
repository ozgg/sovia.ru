class ApplicationController < ActionController::Base
  class UnauthorizedException < Exception
  end

  class ForbiddenException < Exception
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_page, :param_from_request, :current_user, :current_user_has_role?

  # Get current page from request
  #
  # @return [Integer]
  def current_page
    @current_page ||= (params[:page] || 1).to_s.to_i.abs
  end

  # Get current user from authentication token
  #
  # @return [User|nil]
  def current_user
    @current_user ||= Token.user_by_token cookies['token'], true
  end

  # @param [Symbol] role
  def current_user_has_role?(role)
    current_user.is_a?(User) && current_user.has_role?(role)
  end

  # Get parameter from request and normalize it
  #
  # Casts parameter to string in UTF-8 and removes invalid characters
  #
  # @param [Symbol] parameter
  # @return [String]
  def param_from_request(parameter)
    params[parameter].to_s.encode('UTF-8', 'UTF-8', invalid: :replace, replace: '')
  end

  protected

  # Wrapper for "record not found"
  #
  # @return [ActiveRecord::RecordNotFound]
  def record_not_found
    ActiveRecord::RecordNotFound
  end

  # Restrict access for anonymous users
  def restrict_anonymous_access
    redirect_to login_path, alert: t(:please_log_in) unless current_user.is_a? User
  end

  # Для доступа необходимо наличие роли у пользователя
  #
  # Неавторизованных пользователей перенаправляет на главную страницу.
  # Анонимным посетителям предлагается выполнить вход.
  #
  # @param [Symbol] role
  def require_role(role)
    if current_user.is_a? User
      redirect_to root_path, alert: t(:insufficient_role) unless current_user.has_role? role
    else
      redirect_to login_path, alert: t(:please_log_in)
    end
  end

  # Информация об IP-адресе текущего посетителя для сущности
  def tracking_for_entity
    { ip: request.env['HTTP_X_REAL_IP'] || request.remote_ip }
  end

  # Информация о текущем пользователе для сущности
  def owner_for_entity
    { user: current_user }
  end
end
