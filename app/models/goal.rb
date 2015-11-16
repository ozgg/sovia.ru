class Goal < ActiveRecord::Base
  include HasOwner

  belongs_to :user
  has_many :deeds

  enum status: [:issued, :achieved, :rejected]

  validates_presence_of :user_id, :name

  PER_PAGE = 10

  scope :recent, -> { order 'id desc' }

  def self.page_for_user(current_page, current_user)
    current_user.goals.recent.page(current_page).per(PER_PAGE)
  end
end
