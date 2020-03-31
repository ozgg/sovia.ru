# frozen_string_literal: true

# Helper methods for handling invoices
module InvoicesHelper
  # @param [RobokassaInvoice] entity
  # @param [String] text
  # @param [Hash] options
  def admin_robokassa_invoice_link(entity, text = entity.text_for_link, options = {})
    link_to(text, admin_robokassa_invoice_path(id: entity.id), options)
  end

  # @param [RobokassaInvoice] entity
  def robokassa_invoice_state(entity)
    t("activerecord.attributes.robokassa_invoice.states.#{entity.state}")
  end
end
