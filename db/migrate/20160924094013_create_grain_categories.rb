class CreateGrainCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :grain_categories do |t|
      t.integer :grains_count, null: false, default: 0
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.string :name, null: false
    end
  end
end
