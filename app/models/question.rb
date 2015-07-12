class Question < ActiveRecord::Base
  include HasLanguage
  include HasTrace
  include HasOwner

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, length: { minimum: 10, maximum: 500 }
end
