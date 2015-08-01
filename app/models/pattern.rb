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

  # @param [Hash] links
  def links=(links)
    new_links = []
    PatternLink.categories.keys.each do |category|
      new_links += links_in_category category, links[category] if links.has_key? category
    end
    self.pattern_links = new_links
  end

  def links

  end

  protected

  def existing_links(category)
    PatternLink.where(pattern: self).in_category(category).all.to_a
  end

  def links_in_category(category, links_string)
    links_string.split(',').map { |name| link_by_target_name(category, name) unless name.blank? }
  end

  def link_by_target_name(category, target_name)
    target = Pattern.match_or_create_by_name(target_name.squish, self.language)
    PatternLink.by_triplet category, self, target
  end
end
