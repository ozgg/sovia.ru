class Tag < ActiveRecord::Base
  include HasNameWithSlug

  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates_uniqueness_of :slug

  PER_PAGE = 25

  def self.page_for_administrator(current_page)
    order('slug asc').page(current_page).per(PER_PAGE)
  end

  def flags
    {
        active: post_count > 0
    }
  end
end
