class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.timestamps null: false
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.integer :post_count, null: false, default: 0
      t.string :name, null: false
      t.string :slug, null: false, index: true
    end
  end
end
