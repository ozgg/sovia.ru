class DreamGrain < ApplicationRecord
  belongs_to :dream
  belongs_to :grain

  validates_uniqueness_of :grain_id, scope: [:dream_id]
  validate :grain_has_same_owner

  private

  def grain_has_same_owner
    if grain && dream
      unless grain.user == dream.user
        errors.add(:grain, I18n.t('activerecord.errors.models.dream_grain.grain_id.foreign'))
      end
    end
  end
end
