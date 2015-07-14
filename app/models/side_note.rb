class SideNote < ActiveRecord::Base
  include HasLanguage
  include HasOwner
  include HasTrace

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :user_id, :title, :link

  mount_uploader :image, SideNoteUploader
end
