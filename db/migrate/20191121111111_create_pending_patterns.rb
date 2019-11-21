# frozen_string_literal: true

# Create table for pending patterns
class CreatePendingPatterns < ActiveRecord::Migration[5.2]
  def up
    create_pending_patterns unless PendingPattern.table_exists?
  end

  def down
    drop_table :pending_patterns if PendingPattern.table_exists?
  end

  private

  def create_pending_patterns
    create_table :pending_patterns, comment: 'Pending pattern for interpretation' do |t|
      t.references :pattern, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.boolean :processed, default: false, null: false
      t.string :name, null: false, index: true
      t.timestamps
    end
  end
end
