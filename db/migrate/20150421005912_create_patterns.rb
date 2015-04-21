class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.references :language, index: true, null: false
      t.integer :dream_count, null: false, default: 0
      t.string :image
      t.string :name, null: false
      t.string :code, null: false
      t.text :body

      t.timestamps
    end

    add_index :patterns, [:code, :language_id]
    add_index :patterns, [:dream_count, :language_id]
  end
end
