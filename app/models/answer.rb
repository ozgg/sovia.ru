class Answer < ActiveRecord::Base
  include HasOwner
  include HasUser

  belongs_to :question, counter_cache: true
  belongs_to :agent

  validates_presence_of :body, :user
end
