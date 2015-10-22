class Question < ActiveRecord::Base
  include HasTrace
  include HasOwner
  include CommentableByCommunity

  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, length: { minimum: 10, maximum: 500 }

  scope :recent, -> { order 'id desc' }

  PER_PAGE = 10

  def self.recent_list(current_page)
    self.recent.page(current_page).per(PER_PAGE)
  end

  def editable_by?(user)
    owned_by?(user) || UserRole.user_has_role?(user, :administrator)
  end

  def title_for_view
    I18n.t('questions.preview.question')
  end
end
