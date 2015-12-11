class Pattern < ActiveRecord::Base
  include HasTrace
  include HasOwner
  include HasNameWithSlug
  include SortingByTime

  belongs_to :user
  has_many :grains, dependent: :nullify
  has_many :dream_patterns, dependent: :destroy
  has_many :dreams, through: :dream_patterns
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :pattern_links, dependent: :destroy

  validates_uniqueness_of :slug

  mount_uploader :image, ImageUploader

  scope :starting_with, ->(letter) { where 'slug ilike ?', "#{letter}%" }
  scope :good_for_dreambook, -> { where 'description is not null or dream_count > 0' }
  scope :for_queue, -> { where(locked: false).order('dream_count desc, slug asc') }
  scope :locked, -> { where(locked: true) }
  scope :described, -> { where 'description is not null' }

  PER_PAGE = 50

  def self.letters
    %w(А Б В Г Д Е Ё Ж З И Й К Л М Н О П Р С Т У Ф Х Ц Ч Ш Щ Ы Э Ю Я)
  end

  def self.search(query)
    if query.blank?
      []
    else
      self.where('slug like ?', "%#{query}%").by_slug.limit(PER_PAGE)
    end
  end

  def self.dreambook_page(letter, current_page)
    self.starting_with(letter).good_for_dreambook.by_slug.page(current_page).per(PER_PAGE)
  end

  def self.page_for_administrator(current_page)
    by_slug.page(current_page).per(25)
  end

  def self.queue_page_for_administrator(current_page)
    for_queue.page(current_page).per(PER_PAGE)
  end

  def self.page_for_statistics(current_page)
    where('dream_count > 0').order('dream_count desc, slug asc').page(current_page).per(PER_PAGE)
  end

  # @param [Hash] links
  def links=(links)
    new_links = []
    PatternLink.categories.keys.each do |category|
      new_links += set_links_in_category(category, links[category]) if links.has_key? category
    end
    self.pattern_links = new_links
  end

  def title_for_view
    name
  end

  def links
    Hash[PatternLink.categories.keys.map { |category| [category, links_in_category(category)] }]
  end

  def letter
    name.first
  end

  def flags
    {
        described: !description.blank?,
        locked: locked?
    }
  end

  def good_for_dreambook?
    !description.blank? || comments_count > 0 || dream_count > 0 || locked?
  end

  protected

  def set_links_in_category(category, links_string)
    links = links_string.split(',').select { |name| !name.blank? }.map { |name| link_by_target_name category, name }
    links.uniq
  end

  def links_in_category(category)
    PatternLink.in_category(category).where(pattern: self).map { |link| link.target }
  end

  def link_by_target_name(category, target_name)
    target = Pattern.match_or_create_by_name(target_name.squish)
    PatternLink.by_triplet category, self, target
  end
end
