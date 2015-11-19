class CreateDeeds < ActiveRecord::Migration
  def change
    create_table :deeds do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :goal, index: true, foreign_key: true
      t.boolean :deleted, null: false, default: false
      t.string :essence, null: false
    end
  end
end
