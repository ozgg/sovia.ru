class CreateAgentRequests < ActiveRecord::Migration
  def change
    create_table :agent_requests do |t|
      t.references :agent, index: true, null: false
      t.date :day, null: false
      t.integer :requests_count, null: false, default: 0

      t.timestamps
    end

    add_index :agent_requests, [:day, :agent_id], unique: true
  end
end
