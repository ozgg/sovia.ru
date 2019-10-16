# frozen_string_literal: true
# This migration comes from biovision_comment_engine (originally 20190428212122)

# Create row for comments component in components table
class CreateCommentsComponent < ActiveRecord::Migration[5.2]
  def up
    slug = Biovision::Components::CommentsComponent::SLUG
    return if BiovisionComponent.exists?(slug: slug)

    BiovisionComponent.create!(
      slug: slug,
      settings: {
        auto_approve_threshold: 3,
        premoderation: false,
        spam_link_threshold: 0,
        trap_spam: true
      }
    )
  end

  def down
    # No rollback needed
  end
end
