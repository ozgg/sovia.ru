class AddTrackingToComments < ActiveRecord::Migration
  def change
    add_column :comments, :ip, :inet
    add_reference :comments, :agent, index: true
  end
end
