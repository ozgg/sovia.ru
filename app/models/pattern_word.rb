class PatternWord < ApplicationRecord
  belongs_to :pattern, counter_cache: :words_count, touch: false
  belongs_to :word

  validates_uniqueness_of :word_id, scope: [:pattern_id]
end
