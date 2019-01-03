# frozen_string_literal: true
# This migration comes from biovision_base_engine (originally 20181223151515)

# Adding UUID column for users
class AddUuidToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :uuid, :uuid unless column_exists?(:users, :uuid)
  end

  def down
    # No rollback
  end
end
