class Post < ActiveRecord::Base
  include HasLanguage
  include HasTrace
  include HasOwner

  belongs_to :user, counter_cache: true
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :user_id, :title, :lead, :body

  mount_uploader :image, ImageUploader

  def tags_string=(tags_string)

  end

  def cache_tags!

  end

  def editable_by?(user)
    owned_by?(user) || UserRole.user_has_role?(user, :administrator)
  end
end
