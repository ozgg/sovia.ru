class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :entry_type, index: true, null: false
      t.string :letter, null: false
      t.string :name, null: false
      t.string :canonical_name, null: false
      t.integer :entries_count, null: false, default: 0
      t.integer :users_count, null: false, default: 0
      t.text :description

      t.timestamps
    end

    add_index :tags, [:entry_type_id, :letter]
    add_index :tags, [:canonical_name, :entry_type_id], unique: true
    add_index :tags, [:entry_type_id, :entries_count]
  end
end
