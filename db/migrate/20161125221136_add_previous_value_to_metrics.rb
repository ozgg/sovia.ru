class AddPreviousValueToMetrics < ActiveRecord::Migration[5.0]
  def change
    add_column :metrics, :previous_value, :integer, null: false, default: 0
  end
end
