# frozen_string_literal: true

# Usage of pattern in dream
#
# Attributes:
#   created_at [DateTime]
#   dream_id [Dream]
#   pattern_id [Pattern]
#   updated_at [DateTime]
#   weight [Integer]
class DreamPattern < ApplicationRecord
  belongs_to :dream
  belongs_to :pattern, counter_cache: :dreams_count

  before_validation { self.weight = 0 unless weight.to_i.positive? }

  validates_uniqueness_of :pattern_id, scope: [:dream_id]
end
