# frozen_string_literal: true

# Create table for Robokassa invoices
class CreateRobokassaInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :robokassa_invoices, comment: 'Robokassa invoices' do |t|
      t.uuid :uuid, null: false
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.timestamps
      t.integer :state, limit: 2, default: RobokassaInvoice.states[:reserved], null: false
      t.integer :price
      t.string :email
      t.jsonb :data, default: {}, null: false
    end

    add_index :robokassa_invoices, :uuid, unique: true
    add_index :robokassa_invoices, :data, using: :gin
  end
end
