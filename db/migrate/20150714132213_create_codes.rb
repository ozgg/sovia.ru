class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.integer :category, limit: 2, null: false
      t.boolean :activated, null: false, default: false
      t.string :body, null: false
      t.string :payload
    end
  end
end
