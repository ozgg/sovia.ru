class CreateDreamPatterns < ActiveRecord::Migration[5.0]
  def change
    create_table :dream_patterns do |t|
      t.references :dream, foreign_key: true, null: false
      t.references :pattern, foreign_key: true, null: false
    end
  end
end
