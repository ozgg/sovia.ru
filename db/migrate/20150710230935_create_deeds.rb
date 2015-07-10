class CreateDeeds < ActiveRecord::Migration
  def change
    create_table :deeds do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :goal, index: true, foreign_key: true
      t.string :essence, null: false

      t.timestamps null: false
    end
  end
end
