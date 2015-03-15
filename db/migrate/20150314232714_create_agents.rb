class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name
      t.boolean :is_bot, null: false, default: false

      t.timestamps
    end

    add_index :agents, :name
  end
end
