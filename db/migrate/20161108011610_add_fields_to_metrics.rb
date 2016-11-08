class AddFieldsToMetrics < ActiveRecord::Migration[5.0]
  def change
    add_column :metrics, :incremental, :boolean, null: false, default: false
    add_column :metrics, :value, :integer, null: false, default: 0
  end
end
