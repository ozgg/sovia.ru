# frozen_string_literal: true

# Pending pattern for interpretation
#
# Attributes:
#   created_at [DateTime]
#   data [Jsonb]
#   name [String]
#   pattern_id [Pattern]
#   processed [Boolean]
#   updated_at [DateTime]
class PendingPattern < ApplicationRecord
  NAME_LIMIT = 100

  belongs_to :pattern, optional: true

  validates_presence_of :name
  validates_length_of :name, maximum: NAME_LIMIT
  validates_uniqueness_of :name, case_sensitive: false

  scope :processed, ->(v = true) { where(processed: [true, false].include?(v) ? v : v.to_i.positive?) unless v.to_s.blank? }
  scope :name_like, ->(v) { where('name ilike ?', "%#{v}%") unless v.blank? }
  scope :list_for_administration, -> { order('processed asc, weight desc, name asc') }
  scope :filtered, ->(f) { processed(f[:processed]).name_like(f[:name]) }

  # @param [Integer] page
  # @param [Hash] filter
  def self.page_for_administration(page = 1, filter = {})
    filtered(filter).list_for_administration.page(page)
  end

  # @param [Array<String>] list
  def self.enqueue(list)
    list.each do |name|
      pattern = Pattern.find_by('lower(name) = lower(?)', name)
      create(
        name: name.downcase,
        pattern: pattern,
        processed: !pattern.nil?
      )
    end
  end

  # @param [String] summary
  def process!(summary)
    pattern = Pattern.new(name: name, summary: summary)
    if pattern.save
      update(pattern: pattern, processed: true)
    else
      Rails.logger.warn("Could not process pending pattern #{id} as #{summary}")
    end
  end
end
