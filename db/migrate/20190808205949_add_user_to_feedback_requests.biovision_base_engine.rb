# frozen_string_literal: true
# This migration comes from biovision_base_engine (originally 20190610141414)

# Add reference to user from feedback request
class AddUserToFeedbackRequests < ActiveRecord::Migration[5.2]
  def up
    return if column_exists?(:feedback_requests, :user_id)

    add_reference :feedback_requests, :user, foreign_key: { on_update: :cascade, on_delete: :cascade }
  end

  def down
    # No rollback needed
  end
end
