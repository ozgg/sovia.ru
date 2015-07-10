class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.integer :status, null: false
      t.string :name, null: false
      t.text :description

      t.timestamps null: false
    end
  end
end
