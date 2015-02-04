class AddGoalReferenceToDeeds < ActiveRecord::Migration
  def change
    add_reference :deeds, :goal, index: true
  end
end
