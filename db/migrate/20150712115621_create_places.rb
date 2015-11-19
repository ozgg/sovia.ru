class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.float :latitude
      t.float :longitude
      t.integer :azimuth, limit: 2
      t.integer :dreams_count, null: false, default: 0
      t.boolean :deleted, null: false, default: false
      t.string :name, null: false
      t.string :image
      t.text :description
    end
  end
end
