class CreateFillers < ActiveRecord::Migration
  def change
    create_table :fillers do |t|
      t.timestamps null: false
      t.integer :category, limit: 2, null: false
      t.integer :gender, limit: 2
      t.string :title
      t.text :body, null: false
    end
  end
end
