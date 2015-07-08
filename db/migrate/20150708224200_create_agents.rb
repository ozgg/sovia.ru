class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.references :browser, index: true, foreign_key: true
      t.boolean :bot, null: false, default: false
      t.boolean :mobile, null: false, default: false
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :agents, :name
  end
end
