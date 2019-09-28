# frozen_string_literal: true
# This migration comes from biovision_comment_engine (originally 20190428212121)

# Add column with approval flag to comments
class AddApprovedToComments < ActiveRecord::Migration[5.2]
  def up
    # return if column_exists?(:comments, :approved)
    #
    # add_column :comments, :approved, :boolean, default: true, null: false
  end

  def down
    # No rollback needed
  end
end
