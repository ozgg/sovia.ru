class Pattern < ActiveRecord::Base
  include HasLanguage
  include HasTrace
  include HasOwner
  include HasNameWithSlug

  belongs_to :user
  has_many :grains, dependent: :nullify
  has_many :dream_patterns, dependent: :destroy
  has_many :dreams, through: :dream_patterns
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :pattern_links, dependent: :destroy

  validates_uniqueness_of :slug, scope: :language_id

  mount_uploader :image, ImageUploader

  scope :starting_with, ->(letter) { where 'slug like ?', "#{letter}%" }

  def self.letters(locale)
    method = "letters_#{locale}"
    respond_to?(method) ? send(method) : []
  end

  def self.letters_ru
    %w(А Б В Г Д Е Ё Ж З И Й К Л М Н О П Р С Т У Ф Х Ц Ч Ш Щ Ы Э Ю Я)
  end

  def self.letters_en
    %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
  end

  def self.search(language, query)
    if query.blank?
      []
    else
      self.where(language: language).where('slug like ?', "%#{query}%").order('slug asc').limit(20)
    end
  end

  # @param [Hash] links
  def links=(links)
    new_links = []
    PatternLink.categories.keys.each do |category|
      new_links += set_links_in_category(category, links[category]) if links.has_key? category
    end
    self.pattern_links = new_links
  end

  def links
    Hash[PatternLink.categories.keys.map { |category| [category, links_in_category(category)] }]
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
    target = Pattern.match_or_create_by_name(target_name.squish, self.language)
    PatternLink.by_triplet category, self, target
  end
end
