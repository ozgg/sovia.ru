class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :user, index: true
      t.integer :status, null: false, default: 0
      t.string :name, null: false
      t.string :description

      t.timestamps
    end
  end
end
