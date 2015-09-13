class Tag < ActiveRecord::Base
  include HasNameWithSlug

  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates_uniqueness_of :slug
end
