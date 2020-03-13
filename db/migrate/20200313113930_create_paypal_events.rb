# frozen_string_literal: true

# Create table for PayPal events
class CreatePaypalEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :paypal_events, comment: 'PayPal webhook events' do |t|
      t.references :paypal_invoice, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.timestamps
      t.jsonb :data, default: {}, null: false
    end

    add_index :paypal_events, :data, using: :gin
  end
end
