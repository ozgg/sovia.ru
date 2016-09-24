class CreateGrains < ActiveRecord::Migration[5.0]
  def change
    create_table :grains do |t|
      t.timestamps
      t.references :grain_category, foreign_key: true
      t.references :user, foreign_key: true, null: false
      t.integer :dreams_count, null: false, default: 0
      t.string :uuid, null: false
      t.string :name, null: false
      t.string :slug, null: false, index: true
      t.string :image
      t.text :description
    end
  end
end
