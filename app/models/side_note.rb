class SideNote < ActiveRecord::Base
  include HasLanguage
  include HasOwner
  include HasTrace

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :user_id, :title, :link

  mount_uploader :image, SideNoteUploader

  scope :visible, -> { where active: true }

  def self.parameters_for_users
    [:image, :link, :title, :body]
  end

  def self.parameters_for_administrators
    [:active]
  end

  def editable_by?(user)
    owned_by?(user) || UserRole.user_has_role?(user, :administrator)
  end
end
