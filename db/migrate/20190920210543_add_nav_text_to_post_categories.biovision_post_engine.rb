# frozen_string_literal: true
# This migration comes from biovision_post_engine (originally 20190412191919)

# Add column "nav_text" to post categories
class AddNavTextToPostCategories < ActiveRecord::Migration[5.2]
  def up
    # return if column_exists?(:post_categories, :nav_text)
    #
    # add_column :post_categories, :nav_text, :string
  end

  def down
    # No rollback needed
  end
end
