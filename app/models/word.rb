# frozen_string_literal: true

# Word used in dream plots
#
# Attributes
#   body [String]
#   created_at [DateTime]
#   dreams_count [Integer]
#   processed [Boolean]
#   updated_at [DateTime]
class Word < ApplicationRecord
  include Checkable
  include Toggleable

  BODY_LIMIT = 50

  toggleable :processed

  has_many :dream_words, dependent: :delete_all
  has_many :dreams, through: :dream_words
  has_many :pattern_words, dependent: :destroy
  has_many :patterns, through: :pattern_words

  before_validation { self.body = body.to_s.strip.downcase[0..49] }

  validates_presence_of :body
  validates_uniqueness_of :body

  scope :ordered_by_body, -> { order('body asc') }
  scope :processed, ->(f) { where(processed: f.to_i.positive?) unless f.blank? }
  scope :body_like, ->(v) { where('body like ?', "%#{v.downcase}%") unless v.blank? }
  scope :filtered, ->(f) { processed(f[:processed]).body_like(f[:body]) }
  scope :list_for_administration, -> { ordered_by_body }

  # @param [Integer] page
  # @param [Hash] filters
  def self.page_for_administration(page = 1, filters = {})
    list_for_administration.filtered(filters).page(page)
  end

  def self.entity_parameters
    %i[body processed]
  end

  # @param [String] string
  def patterns_string=(string)
    new_pattern_ids = []
    string.downcase.strip.split(/,\s*/).reject(&:blank?).uniq.each do |name|
      pattern = Pattern.find_by(name: name)
      new_pattern_ids << pattern.id unless pattern.nil?
    end
    self.pattern_ids = new_pattern_ids
  end

  def patterns_string
    patterns.map(&:name).join(', ')
  end
end
