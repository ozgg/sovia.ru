# frozen_string_literal

# Table for legacy dreambook entries
class CreateDreambookEntries < ActiveRecord::Migration[5.2]
  def up
    return if DreambookEntry.table_exists?

    create_table :dreambook_entries, comment: 'Legacy dreambook entry' do |t|
      t.timestamps
      t.boolean :described, default: false, null: false
      t.boolean :visible, default: true, null: false
      t.string :name, null: false, index: true
      t.string :summary
      t.text :description
    end
  end

  def down
    drop_table :dreambook_entries if DreambookEntry.table_exists?
  end
end
