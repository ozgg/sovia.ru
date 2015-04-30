class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.references :user, index: true, null: false
      t.references :language, index: true, null: false
      t.references :agent, index: true
      t.inet :ip
      t.integer :privacy, null: false, default: HasPrivacy::PRIVACY_NONE
      t.integer :dreams_count, null: false, default: 0
      t.float :latitude
      t.float :longitude
      t.integer :head_direction
      t.string :image
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
