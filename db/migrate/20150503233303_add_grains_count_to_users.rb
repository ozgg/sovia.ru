class AddGrainsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :grains_count, :integer, null: false, default: 0
  end
end
