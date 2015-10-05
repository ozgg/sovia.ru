class Post < ActiveRecord::Base
  include HasTrace
  include HasOwner
  include CommentableByCommunity

  belongs_to :user, counter_cache: true
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :user_id, :title, :lead, :body

  mount_uploader :image, ImageUploader

  scope :visible, -> { where show_in_list: true }

  def tags_string=(tags_string)
    list_of_tags = []
    tags_string.split(',').each do |tag_name|
      list_of_tags << Tag.match_or_create_by_name(tag_name.squish) unless tag_name.blank?
    end
    self.tags = list_of_tags.uniq
  end

  def cache_tags!
    update tags_cache: tags.order('slug asc').map { |tag| tag.name }
  end

  def editable_by?(user)
    owned_by?(user) || UserRole.user_has_role?(user, :administrator)
  end

  # Get text preview for list of posts
  #
  # @return [String]
  def preview
    lead || first_passage
  end

  # Get the first passage from body
  #
  # @return [String]
  def first_passage
    body.squish.split("\n").first
  end
end
