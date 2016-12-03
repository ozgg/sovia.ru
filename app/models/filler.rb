class Filler < ApplicationRecord
  PER_PAGE = 10

  belongs_to :user, optional: true

  validate :user_should_be_bot
  validates_presence_of :body

  enum gender: User.genders.keys

  scope :queued, -> { order('id asc') }

  # @param [Integer] page
  def self.page_for_administration(page)
    queued.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(user_id gender title body)
  end

  private

  def user_should_be_bot
    if user.is_a?(User) && !user.bot?
      errors.add(:user, I18n.t('activerecord.errors.models.filler.user.not_bot'))
    end
  end
end
