class CreatePatternLinks < ActiveRecord::Migration
  def change
    create_table :pattern_links do |t|
      t.references :pattern, index: true, foreign_key: true, null: false
      t.integer :target_id, null: false
      t.integer :category, limit: 2, null: false
    end

    add_index :pattern_links, [:pattern_id, :target_id, :category]
  end
end
