class Deed < ActiveRecord::Base
  include HasOwner

  belongs_to :user
  belongs_to :goal

  validates_presence_of :user_id, :essence
  validate :goal_has_same_owner

  PER_PAGE = 25

  scope :ordered, -> { order 'id asc' }
  scope :recent, -> { order 'id desc' }

  def self.page_for_user(current_page, current_user)
    owned_by(current_user).recent.page(current_page).per(PER_PAGE)
  end

  def event_time
    created_at.strftime '%d.%m.%Y'
  end

  protected

  def goal_has_same_owner
    if goal.is_a?(Goal) && !goal.owned_by?(self.user)
      errors.add :goal_id, I18n.t('activerecord.errors.models.deed.attribute.foreign')
    end
  end
end
