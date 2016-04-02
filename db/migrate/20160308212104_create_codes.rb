class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.integer :category, limit: 2, null: false
      t.integer :quantity, limit: 2, null: false, default: 1
      t.string :body, null: false
      t.string :payload
    end
  end
end
