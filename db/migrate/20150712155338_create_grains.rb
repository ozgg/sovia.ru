class CreateGrains < ActiveRecord::Migration
  def change
    create_table :grains do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :pattern, index: true, foreign_key: true
      t.integer :dream_count, null: false, default: 0
      t.integer :category, limit: 2
      t.float :latitude
      t.float :longitude
      t.boolean :deleted, null: false, default: false
      t.string :image
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
    end

    add_index :grains, [:slug, :user_id]
  end
end
