class AddTrackingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ip, :inet
    add_reference :users, :agent, index: true
    add_column :users, :bot, :boolean, null: false, default: false
  end
end
