# frozen_string_literal: true
# This migration comes from biovision_post_engine (originally 20191124232323)

# Convert editorial_member_post_types to component settings
class ConvertEditorialPrivileges < ActiveRecord::Migration[5.2]
  def up
    slug = Biovision::Components::PostsComponent::SLUG
    handler = Biovision::Components::BaseComponent.handler(slug)
    EditorialMemberPostType.order('id asc').each do |link|
      handler.user = link.user
      handler.allow_post_type(link.post_type)
    end
  end

  def down
    # No rollback needed
  end
end
