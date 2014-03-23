class ErrorsController < ApplicationController
  layout 'errors'

  def not_found
    render view: '404', status: :not_found
  end

  def show
    render view: status_code.to_s, :status => status_code
  end

  protected

  def status_code
    params[:code] || 500
  end
end
