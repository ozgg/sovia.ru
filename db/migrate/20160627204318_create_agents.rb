class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.timestamps null: false
      t.references :browser, index: true, foreign_key: true
      t.boolean :bot, null: false, default: false
      t.boolean :mobile, null: false, default: false
      t.boolean :active, null: false, default: true
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.string :name, null: false, index: true
    end
  end
end
