class AddPlacesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :places_count, :integer, null: false, default: 0
  end
end
