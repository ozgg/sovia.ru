class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :type, null: false
      t.string :letter, null: false
      t.string :name, null: false
      t.string :canonical_name, null: false
      t.integer :entries_count, null: false, default: 0
      t.integer :users_count, null: false, default: 0
      t.text :description

      t.timestamps
    end

    add_index :tags, [:type, :letter]
    add_index :tags, [:type, :canonical_name], unique: true
    add_index :tags, [:type, :entries_count]
  end
end
