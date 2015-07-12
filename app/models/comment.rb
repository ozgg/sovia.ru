class Comment < ActiveRecord::Base
  include HasLanguage
  include HasOwner
  include HasTrace

  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true

  validates_presence_of :commentable, :body
end
