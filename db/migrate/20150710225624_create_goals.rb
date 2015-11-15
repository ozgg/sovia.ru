class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.timestamps null: false
      t.integer :status, limit: 2, null: false
      t.boolean :deleted, null: false, default: false
      t.string :name, null: false
      t.text :description
    end
  end
end
