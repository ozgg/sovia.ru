class Comment < ActiveRecord::Base
  belongs_to :entry, counter_cache: true
  belongs_to :user, counter_cache: true
  belongs_to :parent, class_name: 'Comment'
  has_many :comments

  validates_presence_of :entry, :body
end
