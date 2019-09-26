# frozen_string_literal: true
# This migration comes from biovision_post_engine (originally 20190420212121)

# Create table for poat layouts
class CreatePostLayouts < ActiveRecord::Migration[5.2]
  def up
    # create_post_layouts unless PostLayout.table_exists?
    # add_reference_to_posts unless column_exists?(:posts, :post_layout_id)
  end

  def down
    # No rollback needed
  end

  private

  def create_post_layouts
    create_table :post_layouts, comment: 'Post layout' do |t|
      t.integer :posts_count, default: 0, null: false
      t.string :slug
      t.string :name
    end
  end

  def add_reference_to_posts
    add_reference :posts, :post_layout, foreign_key: { on_update: :cascade, on_delete: :nullify }
  end
end
