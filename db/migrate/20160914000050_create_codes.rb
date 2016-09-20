class CreateCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :codes do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.references :agent, foreign_key: true
      t.inet :ip
      t.integer :category, limit: 2, null: false
      t.integer :quantity, limit: 2, null: false, default: 1
      t.string :body, null: false
      t.string :payload
    end
  end
end
