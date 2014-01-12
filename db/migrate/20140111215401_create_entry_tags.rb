class CreateEntryTags < ActiveRecord::Migration
  def change
    create_table :entry_tags do |t|
      t.string :letter, null: false
      t.string :name, null: false
      t.string :canonical_name, null: false
      t.integer :dreams_count, null: false, default: 0
      t.integer :users_count, null: false, default: 0
      t.text :description

      t.timestamps
    end

    add_index :entry_tags, :letter
    add_index :entry_tags, :name
    add_index :entry_tags, :canonical_name, unique: true
  end
end
