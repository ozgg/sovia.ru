class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.boolean :significant, null: false, default: true
      t.boolean :locked, null: false, default: false
      t.boolean :processed, null: false, default: false, index: true
      t.integer :dreams_count, null: false, default: 0, index: true
      t.string :body, index: true
    end
  end
end
