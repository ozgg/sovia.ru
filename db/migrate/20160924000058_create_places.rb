class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.references :user, foreign_key: true
      t.integer :dreams_count, null: false, default: 0
      t.string :name, null: false
      t.text :description
    end
  end
end
