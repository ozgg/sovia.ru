class CreateGrains < ActiveRecord::Migration
  def change
    create_table :grains do |t|
      t.references :user, index: true, null: false
      t.references :pattern, index: true
      t.integer :dream_count, null: false, default: 0
      t.integer :category
      t.float :latitude
      t.float :longitude
      t.string :image
      t.string :code, null: false
      t.string :name, null: false
      t.text :body

      t.timestamps
    end

    add_index :grains, [:user_id, :code], unique: true
    add_index :grains, [:user_id, :dream_count]
  end
end
