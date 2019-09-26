# frozen_string_literal: true
# This migration comes from biovision_post_engine (originally 20190715141414)

# Add data column to post_categories
class AddDataToPostCategories < ActiveRecord::Migration[5.2]
  def up
    # return if column_exists? :post_categories, :data
    #
    # add_column :post_categories, :data, :jsonb, default: {}, null: false
  end

  def down
    # No rollback needed
  end
end
