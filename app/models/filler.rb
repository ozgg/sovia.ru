class Filler < ActiveRecord::Base
  belongs_to :language

  validates_presence_of :language, :body

  enum gender: [:female, :male]
  enum queue: [:question]
end
