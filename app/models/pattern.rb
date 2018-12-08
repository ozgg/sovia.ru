# frozen_string_literal: true

# Dream pattern
#
# Attributes
#   created_at [DateTime]
#   dreams_count [Integer]
#   name [String]
#   summary [String]
#   updated_at [DateTime]
#   words_count [Integer]
class Pattern < ApplicationRecord
  include Checkable
  include RequiredUniqueName

  NAME_LIMIT    = 50
  SUMMARY_LIMIT = 255

  has_many :words, dependent: :destroy
  has_many :dream_patterns, dependent: :delete_all
  has_many :dreams, through: :dream_patterns
  has_many :dreambook_entries, dependent: :nullify

  validates_presence_of :summary
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :summary, maximum: SUMMARY_LIMIT

  scope :list_for_visitors, -> { ordered_by_name }
  scope :list_for_administration, -> { ordered_by_name }
  scope :filtered, ->(f) { with_name_like(f[:name]) }

  # @param [Integer] page
  # @param [Hash] filters
  def self.page_for_administration(page = 1, filters = {})
    list_for_administration.filtered(filters).page(page)
  end

  def self.entity_parameters
    %i[name summary]
  end
end
