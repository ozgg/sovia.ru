class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :entry, index: true
      t.integer :parent_id, index: true
      t.references :user, index: true
      t.boolean :is_visible, null: false, default: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
