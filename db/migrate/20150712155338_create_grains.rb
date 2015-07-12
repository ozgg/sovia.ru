class CreateGrains < ActiveRecord::Migration
  def change
    create_table :grains do |t|
      t.references :language, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :pattern, index: true, foreign_key: true
      t.integer :dream_count, null: false, default: 0
      t.integer :category
      t.float :latitude
      t.float :longitude
      t.string :image
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description

      t.timestamps null: false
    end

    add_index :grains, [:slug, :user_id]
  end
end
