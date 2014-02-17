class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :letter, null: false
      t.string :name, null: false
      t.string :canonical_name, null: false
      t.integer :dreams_count, null: false, default: 0
      t.integer :users_count, null: false, default: 0
      t.text :description

      t.timestamps
    end

    add_index :tags, :letter
    add_index :tags, :canonical_name, unique: true
    add_index :tags, :dreams_count
  end
end
