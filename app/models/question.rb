class Question < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :language

  validates_presence_of :owner, :language, :body
end
