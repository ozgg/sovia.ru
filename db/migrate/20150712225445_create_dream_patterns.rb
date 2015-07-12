class CreateDreamPatterns < ActiveRecord::Migration
  def change
    create_table :dream_patterns do |t|
      t.references :dream, index: true, foreign_key: true, null: false
      t.references :pattern, index: true, foreign_key: true, null: false
      t.integer :status, null: false
    end

    add_index :dream_patterns, [:dream_id, :pattern_id]
  end
end
