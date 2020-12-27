# frozen_string_literal: true

# Sleep place
#
# Attributes:
#   dreams_count [Integer]
#   name [String]
#   user_id [User]
#   uuid [UUID]
class SleepPlace < ApplicationRecord
  include Checkable
  include HasOwner
  include HasUuid

  NAME_LIMIT = 50

  belongs_to :user
  has_many :dreams, dependent: :nullify

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :user_id
  validates_length_of :name, maximum: NAME_LIMIT

  scope :ordered_by_name, -> { order('name asc') }
  scope :ordered_by_count, -> { order('dreams_count desc, name asc') }
  scope :list_for_owner, ->(v) { owned_by(v).ordered_by_count }
  scope :list_for_administration, -> { order('id desc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.entity_parameters
    %i[name]
  end

  def text_for_link
    name
  end
end
