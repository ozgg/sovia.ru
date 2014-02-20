class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.references :user, index: true
      t.string :type, null: false
      t.integer :privacy, null: false, default: Entry::PRIVACY_NONE
      t.string :title
      t.string :url_title
      t.text :body, null: false
      t.integer :comments_count, null: false, default: 0

      t.timestamps
    end

    add_index :entries, [:type, :privacy]
  end
end
