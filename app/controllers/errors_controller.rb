class ErrorsController < ApplicationController
  skip_before_action :set_locale
  skip_after_action :track_agent

  layout 'errors'

  def not_found
    render '404', status: :not_found
  end

  def unauthorized
    render '401', status: :unauthorized
  end

  def show
    render status_code.to_s, :status => status_code
  end

  protected

  def status_code
    params[:code] || 500
  end
end
