# frozen_string_literal: true

# Service
#
# Attributes:
#   active [boolean]
#   created_at [DateTime]
#   data [jsonb]
#   description [text]
#   duration [integer], optional
#   highlighted [boolean]
#   image [SimpleImageUploader], optional
#   lead [string], optional
#   name [string]
#   old_price [integer], optional
#   price [integer]
#   priority [integer]
#   slug [string]
#   updated_at [DateTime]
#   users_count [integer]
#   visible [boolean]
class Service < ApplicationRecord
  include Checkable
  include FlatPriority
  include RequiredUniqueSlug
  include Toggleable

  DESCRIPTION_LIMIT = 5000
  LEAD_LIMIT = 255
  NAME_LIMIT = 255
  SLUG_LIMIT = 30
  SLUG_PATTERN = /\A[a-z][-_a-z0-9]*[a-z0-9]\z/i.freeze
  SLUG_PATTERN_HTML = '^[a-zA-Z][-_a-zA-Z0-9]*[a-zA-Z0-9]$'

  toggleable :active, :highlighted, :visible

  mount_uploader :image, SimpleImageUploader

  has_many :user_services, dependent: :delete_all

  validates_presence_of :description, :name, :price
  validates_length_of :description, maximum: DESCRIPTION_LIMIT
  validates_length_of :lead, maximum: LEAD_LIMIT
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_format_of :slug, with: SLUG_PATTERN
  validates_numericality_of :duration, greater_than: 0, allow_nil: true
  validates_numericality_of :old_price, greater_than: 0, allow_nil: true
  validates_numericality_of :price, greater_than_or_equal_to: 0

  scope :active, -> { where(active: true) }
  scope :visible, -> { where(visible: true) }
  scope :list_for_visitors, -> { active.visible.ordered_by_priority }
  scope :list_for_administration, -> { ordered_by_priority }

  def self.entity_parameters
    fields = %i[
      description duration image lead name old_price price priority slug
    ]
    fields + toggleable_attributes
  end
end
