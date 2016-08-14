class Figure < ApplicationRecord
  SLUG_PATTERN = /[a-zA-Z0-9_]{1,30}/
  LINK_PATTERN = /\[figure (?<id>[a-zA-Z0-9]{1,30})\]/

  belongs_to :post

  mount_uploader :image, PostImageUploader

  validates_presence_of :slug, :image
  validates_uniqueness_of :slug, scope: [:post_id]
  validate :slug_should_be_valid

  after_initialize :generate_slug

  def self.entity_parameters
    %i(image caption alt_text)
  end

  def self.creation_parameters
    entity_parameters + %i(slug)
  end

  # @param [Post] post
  def self.next_slug(post)
    where(post: post).count + 1
  end

  def text_for_alt
    if alt_text.blank?
      caption.blank? ? post.title : caption
    else
      alt_text
    end
  end

  # @param [User] user
  def editable_by?(user)
    post.editable_by? user
  end

  private

  def generate_slug
    if id.nil? && slug.blank?
      self.slug = Figure.next_slug(post)
    end
  end

  def slug_should_be_valid
    unless self.slug =~ SLUG_PATTERN
      errors.add(:slug, I18n.t('activerecord.errors.models.figure.attributes.slug.invalid'))
    end
  end
end
