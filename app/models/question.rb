class Question < ApplicationRecord
  include HasOwner

  PER_PAGE = 10

  belongs_to :user
  belongs_to :agent, optional: true
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :body

  scope :recent, -> { order 'id desc' }
  scope :visible, -> { where deleted: false }

  # @param [Integer] page
  def self.page_for_administration(page)
    recent.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitors(page)
    visible.recent.page(page).per(PER_PAGE)
  end

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page)
    owned_by(user).visible.recent.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(body)
  end

  def editable_by?(user)
    owned_by?(user) || UserRole.user_has_role?(user, :administrator)
  end
end
