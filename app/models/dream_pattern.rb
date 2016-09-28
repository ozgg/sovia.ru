class DreamPattern < ApplicationRecord
  belongs_to :dream
  belongs_to :pattern, counter_cache: :dreams_count

  validates_uniqueness_of :pattern_id, scope: [:dream_id]
end
