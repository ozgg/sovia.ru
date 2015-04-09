class Question < ActiveRecord::Base
  include HasOwner
  include HasLanguage

  belongs_to :agent
  validates_presence_of :owner, :body
end
