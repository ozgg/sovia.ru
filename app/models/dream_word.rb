# frozen_string_literal: true

# Usage of word in dream
#
# Attributes:
#   created_at [DateTime]
#   dream_id [Dream]
#   updated_at [DateTime]
#   weight [Integer]
#   word_id [Word]
class DreamWord < ApplicationRecord
  belongs_to :dream
  belongs_to :word, counter_cache: :dreams_count

  before_validation { self.weight = 0 unless weight.to_i.positive? }

  validates_uniqueness_of :word_id, scope: [:dream_id]
end
