class Post < ActiveRecord::Base
  include HasTrace
  include HasOwner
  include CommentableByCommunity
  include SortingByTime

  belongs_to :user, counter_cache: true
  has_many :post_tags, dependent: :delete_all
  has_many :tags, through: :post_tags
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :user_id, :title, :lead, :body

  mount_uploader :image, ImageUploader

  scope :visible, -> { where show_in_list: true }
  scope :recent, -> (show_hidden) { show_hidden ? order('id desc') : visible.order('id desc') }

  PER_PAGE = 10

  def self.page_for_user(current_page, current_user)
    show_hidden = UserRole.user_has_role?(current_user, :administrator)
    recent(show_hidden).page(current_page).per(PER_PAGE)
  end

  def self.tagged_page_for_user(tag, current_page, current_user)
    show_hidden = UserRole.user_has_role?(current_user, :administrator)
    recent(show_hidden).joins(:post_tags).where(post_tags: { tag: tag }).page(current_page).per(PER_PAGE)
  end

  def self.archive_page(year, month, current_page)
    first_day = '%04d-%02d-01 00:00:00' % [year, month]
    recent(false).where("date_trunc('month', created_at) = '#{first_day}'").page(current_page).per(PER_PAGE)
  end

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

  def title_for_view
    title
  end

  def flags
    {
        visible: show_in_list
    }
  end

  # Get the first passage from body
  #
  # @return [String]
  def first_passage
    body.squish.split("\n").first
  end

  def toggle_visibility!
    update show_in_list: !show_in_list
  end
end
