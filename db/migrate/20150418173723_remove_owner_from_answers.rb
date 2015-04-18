class RemoveOwnerFromAnswers < ActiveRecord::Migration
  def change
    remove_column :answers, :owner_id, :string
    remove_column :answers, :owner_type, :string
  end
end
