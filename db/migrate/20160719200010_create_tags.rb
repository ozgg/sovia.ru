class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.timestamps
      t.integer :posts_count, null: false, default: 0
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.string :name, null: false
      t.string :slug, null: false
    end
  end
end
