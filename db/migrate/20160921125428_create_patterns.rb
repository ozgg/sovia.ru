class CreatePatterns < ActiveRecord::Migration[5.0]
  def change
    create_table :patterns do |t|
      t.timestamps
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.integer :dreams_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.string :name, null: false, index: true
      t.string :image
      t.string :essence
      t.text :description
    end
  end
end
