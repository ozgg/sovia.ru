# frozen_string_literal: true

# Dreambook pattern
#
# Attributes:
#   created_at [DateTime]
#   data [jsonb]
#   description [text], optional
#   dream_count [integer]
#   name [string]
#   processed [boolean]
#   simple_image_id [SimpleImage], optional
#   summary [string], optional
#   updated_at [DateTime]
#   uuid [uuid]
#   user_id [User], optional
#   visible [boolean]
class Pattern < ApplicationRecord
  include Checkable
  include HasOwner
  include HasSimpleImage
  include HasUuid
  include Toggleable

  NAME_LIMIT = 100
  SUMMARY_LIMIT = 255

  toggleable :visible, :processed

  belongs_to :user, optional: true

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :user_id
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :summary, maximum: SUMMARY_LIMIT

  scope :ordered_by_name, -> { order('name asc') }
  scope :letter, ->(v) { where('name ilike ?', "#{v[0]}%") unless v.blank? }
  scope :search, ->(v) { where("patterns_tsvector(name, summary, description) @@ phraseto_tsquery('russian', ?)", v) unless v.blank? }
  scope :recent, -> { order('id desc') }
  scope :list_for_visitors, -> { where(user_id: nil).ordered_by_name }
  scope :list_for_administration, -> { ordered_by_name }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.entity_parameters
    %i[description name processed simple_image_id summary visible]
  end

  # @param [String] name
  def self.[](name)
    find_by('user_id is null and name ilike ?', name)
  end
end
