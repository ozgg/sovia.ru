# This migration comes from biovision_base_engine (originally 20170301000102)
class CreateAgents < ActiveRecord::Migration[5.0]
  def change
    change_table :agents do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
