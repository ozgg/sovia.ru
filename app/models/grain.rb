class Grain < ApplicationRecord
  include HasOwner

  PER_PAGE = 20

  belongs_to :grain_category, optional: true, counter_cache: true
  belongs_to :user

  validates_presence_of :name, :slug
  validates_uniqueness_of :slug, scope: [:user_id]

  after_initialize :set_uuid
  before_validation :normalize_name, :generate_slug

  mount_uploader :image, GrainImageUploader

  scope :ordered_by_slug, -> { order 'slug asc' }

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page)
    owned_by(user).ordered_by_slug.page(page).per(PER_PAGE)
  end

  # @param [User] user
  # @param [String] name
  def self.match_by_name(user, name)
    find_by user: user, slug: Canonizer.canonize(name)
  end

  # @param [User] user
  # @param [String] name
  def self.match_by_name!(user, name)
    result = match_by_name user, name
    raise ActiveRecord::RecordNotFound if result.nil?
    result
  end

  # @param [User] user
  # @param [String] name
  def self.match_or_create_by_name(user, name)
    entity = find_by user: user, slug: Canonizer.canonize(name)
    entity || create(user: user, name: name)
  end

  def self.entity_parameters
    %i(grain_category_id name image description)
  end

  private

  def set_uuid
    if uuid.nil?
      self.uuid = SecureRandom.uuid
    end
  end

  def normalize_name
    self.name = name.to_s.squish[0..49]
  end

  def generate_slug
    self.slug = Canonizer.canonize self.name
  end
end
