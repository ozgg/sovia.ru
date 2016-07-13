class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_page, :param_from_request

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

  protected

  # Wrapper for "record not found"
  #
  # @return [ActiveRecord::RecordNotFound]
  def record_not_found
    ActiveRecord::RecordNotFound
  end

  def agent
    @agent ||= Agent.named(request.user_agent || 'n/a')
  end

  def tracking_for_entity
    { agent: agent, ip: request.env['HTTP_X_REAL_IP'] || request.remote_ip }
  end
end
