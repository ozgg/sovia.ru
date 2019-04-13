# frozen_string_literal: true

# Link between word and pattern
#
# Attributes:
#   created_at [DateTime]
#   pattern_id [Pattern]
#   updated_at [DateTime]
#   word_id [Word]
class PatternWord < ApplicationRecord
  belongs_to :pattern, counter_cache: :words_count
  belongs_to :word, counter_cache: :patterns_count

  validates_uniqueness_of :word_id, scope: [:pattern_id]
end
