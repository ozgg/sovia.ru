class CreateFillers < ActiveRecord::Migration[5.0]
  def change
    create_table :fillers do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.integer :gender, limit: 2
      t.string :title
      t.text :body
    end
  end
end
