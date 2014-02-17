class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.references :user, index: true
      t.references :entry_type, index: true, null: false
      t.integer :privacy, null: false, default: Entry::PRIVACY_NONE
      t.string :title
      t.string :url_title
      t.text :body, null: false
      t.integer :comments_count, null: false, default: 0

      t.timestamps
    end

    add_index :entries, [:entry_type_id, :privacy]
  end
end
