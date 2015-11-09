class SideNote < ActiveRecord::Base
  include HasOwner
  include HasTrace

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :user_id, :title, :link

  mount_uploader :image, SideNoteUploader

  PER_PAGE = 25

  scope :visible, -> { where active: true }
  scope :recent, -> { order 'id desc' }

  def self.random_note
    max_offset = visible.count
    if max_offset > 0
      visible.offset(Time.now.to_i % max_offset).first
    end
  end

  def self.page_for_administrator(current_page)
    recent.page(current_page).per(PER_PAGE)
  end

  def self.page_for_users(current_page)
    visible.recent.page(current_page).per(PER_PAGE)
  end

  def self.parameters_for_users
    [:image, :link, :title, :body]
  end

  def self.parameters_for_administrators
    [:active]
  end

  def editable_by?(user)
    owned_by?(user) || UserRole.user_has_role?(user, :administrator)
  end

  def flags
    {
        active: active?
    }
  end
end
