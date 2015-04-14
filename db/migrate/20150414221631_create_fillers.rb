class CreateFillers < ActiveRecord::Migration
  def change
    create_table :fillers do |t|
      t.integer :queue, null: false
      t.integer :gender
      t.references :language, index: true, null: false
      t.string :title
      t.string :body, null: false

      t.timestamps
    end
  end
end
