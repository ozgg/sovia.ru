class Answer < ActiveRecord::Base
  include HasOwner

  belongs_to :question
  belongs_to :agent

  validates_presence_of :body, :owner
end
