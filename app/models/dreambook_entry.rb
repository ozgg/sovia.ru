# frozen_string_literal: true

# Legacy dreambook entry
#
# Attributes:
#   created_at [DateTime]
#   described [Boolean]
#   description [Text], optional
#   name [String]
#   pattern_id [Pattern], optional
#   summary [String], optional
#   updated_at [DateTime]
#   visible [Boolean]
class DreambookEntry < ApplicationRecord
  include Checkable
  include RequiredUniqueName
  include Toggleable

  DESCRIPTION_LIMIT = 65_535
  LETTERS           = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЭЮЯ'
  NAME_LIMIT        = 50
  SUMMARY_LIMIT     = 255

  toggleable :described, :visible

  belongs_to :pattern, optional: true

  validates_length_of :description, maximum: DESCRIPTION_LIMIT
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :summary, maximum: SUMMARY_LIMIT

  scope :described, ->(f) { where(described: f.to_i.positive?) unless f.nil? }
  scope :visible, -> { where(visible: true) }
  scope :letter, ->(v) { where('name ilike ?', "#{v[0]}%") unless v.blank? }
  scope :list_for_visitors, -> { visible.ordered_by_name }
  scope :list_for_administration, -> { ordered_by_name }
  scope :filtered, ->(f) { described(f[:described]).with_name_like(f[:name]) }

  # @param [Integer] page
  # @param [Hash] filters
  def self.page_for_administration(page = 1, filters = {})
    list_for_administration.filtered(filters).page(page)
  end

  # @param [Integer] page
  def self.page_for_visitors(page = 1)
    list_for_visitors.page(page)
  end

  # @param [String] string
  def self.match_by_name(string)
    find_by('name ilike ?', string)
  end

  def self.entity_parameters
    %i[described description name pattern_id summary visible]
  end
end
