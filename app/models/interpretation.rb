# frozen_string_literal: true

# Interpretation request for dream
#
# Attributes:
#   body [text], optional
#   created_at [DateTime]
#   dream_id [Dream], optional
#   solved [boolean]
#   updated_at [DateTime]
#   user_id [User]
#   uuid [uuid]
class Interpretation < ApplicationRecord
  include Checkable
  include HasOwner
  include HasUuid
  include Toggleable

  BODY_LIMIT = 5000
  STATE_CREATED = 'created'
  STATE_ERROR = 'error'
  STATE_EXISTS = 'exists'
  STATE_NO_DREAM = 'no_dream'
  STATE_NO_REQUESTS = 'no_requests'

  toggleable :solved

  belongs_to :user
  belongs_to :dream, optional: true
  has_many :interpretation_messages, dependent: :delete_all

  validates_length_of :body, maximum: BODY_LIMIT

  scope :recent, -> { order('id desc') }
  scope :solved, ->(f) { where(solved: f.to_i.positive?) unless f.blank? }
  scope :list_for_administration, -> { recent }
  scope :list_for_owner, ->(v) { owned_by(v).recent }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page = 1)
    list_for_owner(user).page(page)
  end

  def message_count
    interpretation_messages.count
  end

  def title
    dream&.title!
  end

  def text_for_link
    title
  end
end
