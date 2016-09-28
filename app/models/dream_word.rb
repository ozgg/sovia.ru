class DreamWord < ApplicationRecord
  belongs_to :dream
  belongs_to :word, counter_cache: :dreams_count

  validates_uniqueness_of :word_id, scope: [:dream_id]
end
