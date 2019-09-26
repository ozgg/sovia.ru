# frozen_string_literal: true
# This migration comes from biovision_post_engine (originally 20190801161616)

# Add posts to biovision components
class AddPostsComponent < ActiveRecord::Migration[5.2]
  def up
    # return if BiovisionComponent.where(slug: 'posts').exists?
    #
    # BiovisionComponent.create(slug: 'posts')
  end

  def down
    # No rollback needed
  end
end
