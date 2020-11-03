# frozen_string_literal: true

# Dream patterns management
class RobokassaInvoicesController < AdminController
  before_action :set_entity

  # delete /patterns/:id
  def destroy
    flash[:notice] = t('.success') if @entity.destroy

    redirect_to(admin_robokassa_invoices_path)
  end

  protected

  def component_class
    Biovision::Components::DreamsComponent
  end

  def set_entity
    @entity = RobokassaInvoice.find_by(id: params[:id])
    handle_http_404('Cannot find robokassa_invoice') if @entity.nil?
  end
end
