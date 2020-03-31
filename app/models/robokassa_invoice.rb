# frozen_string_literal: true

# Robokassa invoice
#
# Attributes:
#   agent_id [Agent], optional
#   created_at [DateTime]
#   data [JSONB]
#   email [String], optional
#   ip [Inet], optional
#   price [Integer]
#   state [Integer], enum
#   updated_at [DateTime]
#   uuid [UUID]
class RobokassaInvoice < ApplicationRecord
  include HasOwner
  include HasUuid

  EMAIL_LIMIT = 255

  enum state: %i[reserved paid cancelled]

  belongs_to :user, optional: true
  belongs_to :agent, optional: true

  validates_length_of :email, maximum: EMAIL_LIMIT
  validates_numericality_of :price, greater_than_or_equal_to: 0

  scope :recent, -> { order('id desc') }
  scope :list_for_administration, -> { recent }
end
