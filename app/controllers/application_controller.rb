class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_page, :param_from_request, :current_user, :current_user_has_role?

  # Get current page from request
  #
  # @return [Integer]
  def current_page
    @current_page ||= (params[:page] || 1).to_s.to_i.abs
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

  # Get current user from token cookie
  #
  # @return [User|nil]
  def current_user
    @current_user ||= Token.user_by_token cookies['token'], true
  end

  # @param [Symbol] role
  def current_user_has_role?(*role)
    current_user.is_a?(User) && current_user.has_role?(*role)
  end

  protected

  # Wrapper for "record not found"
  #
  # @return [ActiveRecord::RecordNotFound]
  def record_not_found
    ActiveRecord::RecordNotFound
  end

  def restrict_anonymous_access
    redirect_to login_path, alert: t(:please_log_in) unless current_user.is_a? User
  end

  # @param [Symbol] role
  def require_role(*role)
    if current_user.is_a? User
      redirect_to root_path, alert: t(:insufficient_role) unless current_user.has_role? *role
    else
      redirect_to login_path, alert: t(:please_log_in)
    end
  end

  # @return [Agent]
  def agent
    @agent ||= Agent.named(request.user_agent || 'n/a')
  end

  # @param [ApplicationRecord] entity
  def add_tracking(entity)
    entity.agent = agent
    entity.ip = request.env['HTTP_X_REAL_IP'] || request.remote_ip
  end

  # @param [ApplicationRecord] entity
  def assign_owner(entity)
    entity.user = current_user
  end

  # @return [Hash]
  def tracking_for_entity
    { agent: agent, ip: request.env['HTTP_X_REAL_IP'] || request.remote_ip }
  end

  # user id for new entity
  def owner_for_entity
    { user: current_user }
  end
end
