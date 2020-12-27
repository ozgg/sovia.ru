# frozen_string_literal: true

# Link between dream and pattern
#
# Attributes:
#   dream_id [Dream]
#   pattern_id [Pattern]
class DreamPattern < ApplicationRecord
  belongs_to :dream
  belongs_to :pattern, counter_cache: :dream_count

  validates_uniqueness_of :pattern_id, scope: :dream_id
end
