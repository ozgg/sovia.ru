class DreamWord < ApplicationRecord
  belongs_to :dream
  belongs_to :word

  validates_uniqueness_of :word_id, scope: [:dream_id]
end
