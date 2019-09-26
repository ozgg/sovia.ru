# frozen_string_literal: true
# This migration comes from biovision_post_engine (originally 20190410101010)

# Add flag for avoiding post parsing
class AddAvoidParsingToPosts < ActiveRecord::Migration[5.2]
  def up
    # return if column_exists?(:posts, :avoid_parsing)
    #
    # add_column :posts, :avoid_parsing, :boolean, default: false, null: false
  end

  def down
    # No rollback needed
  end
end
