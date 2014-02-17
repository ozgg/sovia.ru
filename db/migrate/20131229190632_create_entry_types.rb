class CreateEntryTypes < ActiveRecord::Migration
  def change
    create_table :entry_types do |t|
      t.string :name, null: false
      t.integer :entries_count, null: false, default: 0
      t.integer :tags_count, null: false, default: 0
    end

    add_index :entry_types, :name, unique: true
  end
end
