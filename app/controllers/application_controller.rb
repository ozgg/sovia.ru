class ApplicationController < ActionController::Base
  class UnauthorizedException < Exception
  end

  class ForbiddenException < Exception
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
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

end
