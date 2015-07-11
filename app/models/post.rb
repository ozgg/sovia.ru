class Post < ActiveRecord::Base
  include HasLanguage
  include HasTrace
  include HasOwner

  belongs_to :user, counter_cache: true
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates_presence_of :user_id, :title, :lead, :body
end
