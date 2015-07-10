class Post < ActiveRecord::Base
  include HasLanguage
  include HasTrace
  include HasOwner

  belongs_to :user, counter_cache: true

  validates_presence_of :user_id, :title, :lead, :body
end
