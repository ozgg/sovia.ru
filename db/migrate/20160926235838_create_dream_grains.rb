class CreateDreamGrains < ActiveRecord::Migration[5.0]
  def change
    create_table :dream_grains do |t|
      t.references :dream, foreign_key: true, null: false
      t.references :grain, foreign_key: true, null: false
    end
  end
end
