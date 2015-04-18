class Question < ActiveRecord::Base
  include HasOwner
  include HasUser
  include HasLanguage

  belongs_to :agent
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates_presence_of :user, :body
  validates_length_of :body, maximum: 500
end
