# frozen_string_literal: true

# Create component entry for invoices and table for paypal invoices
class CreateInvoices < ActiveRecord::Migration[5.2]
  def up
    create_component unless PaypalInvoice.table_exists?
    create_paypal_invoices
  end

  def down
    drop_table :paypal_invoices if PaypalInvoice.table_exists?
  end

  private

  def create_component
    BiovisionComponent.create(slug: Biovision::Components::InvoicesComponent.slug)
  end

  def create_paypal_invoices
    create_table :paypal_invoices, comment: 'PayPal invoices' do |t|
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.timestamps
      t.uuid :uuid, null: false
      t.boolean :paid, default: false, null: false
      t.integer :amount, null: false
      t.jsonb :data, default: {}, null: false
    end

    add_index :paypal_invoices, :uuid, unique: true
    add_index :paypal_invoices, :data, using: :gin
  end
end
