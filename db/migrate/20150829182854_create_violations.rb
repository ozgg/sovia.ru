class CreateViolations < ActiveRecord::Migration
  def change
    create_table :violations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :agent, index: true, foreign_key: true, null: false
      t.inet :ip, null: false
      t.integer :category, null: false
      t.text :body

      t.timestamps null: false
    end
  end
end
