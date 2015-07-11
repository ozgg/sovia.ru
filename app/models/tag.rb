class Tag < ActiveRecord::Base
  include HasLanguage
  include HasNameWithSlug

  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates_uniqueness_of :slug, scope: [:language]
end
