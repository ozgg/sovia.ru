class PostTag < ApplicationRecord
  belongs_to :post
  belongs_to :tag, counter_cache: :posts_count, touch: false

  validates_uniqueness_of :tag, scope: [:post]
end
