class RemoveOwnerFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :owner_id, :string
    remove_column :questions, :owner_type, :string
  end
end
