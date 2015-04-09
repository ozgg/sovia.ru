class Question < ActiveRecord::Base
  include HasOwner
  include HasLanguage

  validates_presence_of :owner, :body
end
