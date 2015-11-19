class CreateViolations < ActiveRecord::Migration
  def change
    create_table :violations do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true
      t.references :agent, index: true, foreign_key: true, null: false
      t.inet :ip, null: false
      t.integer :category, limit: 2, null: false
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.text :body
    end
  end
end
