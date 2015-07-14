class CreateDreamFactors < ActiveRecord::Migration
  def change
    create_table :dream_factors do |t|
      t.references :dream, index: true, foreign_key: true, null: false
      t.integer :factor, null: false
    end
  end
end
