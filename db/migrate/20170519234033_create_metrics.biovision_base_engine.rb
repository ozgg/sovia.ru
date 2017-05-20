# This migration comes from biovision_base_engine (originally 20170301000001)
class CreateMetrics < ActiveRecord::Migration[5.0]
  def change
    change_table :metrics do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean :start_with_zero, default: false, null: false
      t.boolean :show_on_dashboard, default: true, null: false
      t.integer :default_period, limit: 2, default: 7, null: false
    end
  end
end
