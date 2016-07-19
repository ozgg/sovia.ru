class Post < ApplicationRecord
  belongs_to :user
  belongs_to :agent, optional: true
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
end
