# frozen_string_literal: true

# Dreambook search query
#
# Attributes:
#   agent_id [Agent], optional
#   body [String]
#   created_at [DateTime]
#   ip [Inet], optional
#   updated_at [DateTime]
#   user_id [User], optional
class DreambookQuery < ApplicationRecord
  include HasOwner

  belongs_to :user, optional: true
  belongs_to :agent, optional: true

  before_save { self.body = body.to_s[0..254] }

  scope :list_for_administration, -> { order('id desc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end
end
