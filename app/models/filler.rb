class Filler < ActiveRecord::Base
  enum category: [:question, :dream]
  enum gender: [:female, :male]

  validates_presence_of :body
end
