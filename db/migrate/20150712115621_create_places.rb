class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.float :latitude
      t.float :longitude
      t.integer :azimuth
      t.integer :dreams_count, null: false, default: 0
      t.string :name, null: false
      t.string :image
      t.text :description

      t.timestamps null: false
    end
  end
end
