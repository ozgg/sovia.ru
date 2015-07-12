class CreateDreamGrains < ActiveRecord::Migration
  def change
    create_table :dream_grains do |t|
      t.references :dream, index: true, foreign_key: true, null: false
      t.references :grain, index: true, foreign_key: true, null: false
    end

    add_index :dream_grains, [:dream_id, :grain_id]
  end
end
