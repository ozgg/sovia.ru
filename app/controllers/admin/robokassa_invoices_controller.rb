# frozen_string_literal: true

# Administrative part of Robokassa invoices management
class Admin::RobokassaInvoicesController < AdminController
  before_action :set_entity, except: :index

  # get /admin/robokassa_invoices
  def index
    @collection = RobokassaInvoice.page_for_administration(current_page)
  end

  # get /admin/robokassa_invoices/:id
  def show
  end

  private

  def component_class
    Biovision::Components::DreamsComponent
  end

  def set_entity
    @entity = RobokassaInvoice.find_by(id: params[:id])
    handle_http_404('Cannot find robokassa_invoice') if @entity.nil?
  end
end
