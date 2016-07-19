class Tag < ApplicationRecord
  PER_PAGE = 20

  validates_presence_of :name, :slug
  validates_uniqueness_of :slug
  before_validation :normalize_name, :generate_slug

  scope :ordered_by_slug, -> { order 'slug asc' }
  scope :visible, -> { where deleted: false }

  # @param [Integer] page
  def self.page_for_administration(page)
    ordered_by_slug.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitors(page)
    visible.ordered_by_slug.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(name)
  end

  # @param [String] name
  def self.match_by_name(name)
    find_by slug: Canonizer.canonize(name)
  end

  # @param [String] name
  def self.match_by_name!(name)
    result = match_by_name name
    raise ActiveRecord::RecordNotFound if result.nil?
    result
  end

  # @param [String] name
  def self.match_or_create_by_name(name)
    entity = find_by slug: Canonizer.canonize(name)
    entity || create(name: name)
  end

  def name_for_url
    Canonizer.urlize self.name
  end

  private

  def normalize_name
    self.name = name.to_s.squish[0..49]
  end

  def generate_slug
    self.slug = Canonizer.canonize self.name
  end
end
