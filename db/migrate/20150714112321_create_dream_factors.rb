class CreateDreamFactors < ActiveRecord::Migration
  def change
    create_table :dream_factors do |t|
      t.references :dream, index: true, foreign_key: true, null: false
      t.integer :factor, limit: 2, null: false
    end
  end
end
