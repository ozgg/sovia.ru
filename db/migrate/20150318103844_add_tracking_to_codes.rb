class AddTrackingToCodes < ActiveRecord::Migration
  def change
    add_reference :codes, :agent, index: true
    add_column :codes, :ip, :inet
  end
end
