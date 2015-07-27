class Deed < ActiveRecord::Base
  include HasOwner

  belongs_to :user
  belongs_to :goal

  validates_presence_of :user_id, :essence
  validate :goal_has_same_owner

  protected

  def goal_has_same_owner
    if goal.is_a?(Goal) && !goal.owned_by?(self.user)
      errors.add :goal_id, I18n.t('activerecord.errors.models.deed.attribute.foreign')
    end
  end
end
