class ErrorsController < ApplicationController
  layout 'errors'

  def not_found
    render '404', status: :not_found
  end

  def show
    render status_code.to_s, :status => status_code
  end

  protected

  def status_code
    params[:code] || 500
  end
end