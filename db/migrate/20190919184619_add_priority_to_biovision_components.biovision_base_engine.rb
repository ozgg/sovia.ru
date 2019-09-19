# frozen_string_literal: true
# This migration comes from biovision_base_engine (originally 20190826111111)

# Add priority column for components table
class AddPriorityToBiovisionComponents < ActiveRecord::Migration[5.2]
  def up
    return if column_exists? :biovision_components, :priority

    add_column :biovision_components, :priority, :integer, limit: 2, default: 1, null: false
  end

  def down
    # No rollback needed
  end
end
