class Question < ActiveRecord::Base
  include HasLanguage
  include HasTrace
  include HasOwner

  belongs_to :user

  validates :body, length: { minimum: 10, maximum: 500 }
end
