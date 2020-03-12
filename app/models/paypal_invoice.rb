# frozen_string_literal: true

# PayPal invoice
# 
# Attributes:
#   agent_id [Agent], optional
#   amount [integer]
#   created_at [DateTime]
#   data [jsonb]
#   ip [inet], optional
#   paid [boolean]
#   updated_at [DateTime]
#   user_id [User]
#   uuid [uuid]
class PaypalInvoice < ApplicationRecord
  include HasOwner
  include HasUuid

  belongs_to :user
  belongs_to :agent, optional: true

  validates_numericality_of :amount, greater_than_or_equal_to: 1

  scope :recent, -> { order('id desc') }
  scope :list_for_owner, ->(v) { owned_by(v).recent }
  scope :list_for_administration, -> { recent }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def name
    user.profile_name
  end

  def quantity
    (data.dig('sovia', 'quantity') || 1).to_i
  end
end
