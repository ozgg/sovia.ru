class Language < ActiveRecord::Base
  validates_presence_of :code, :slug
  validates_uniqueness_of :code

  has_many :tags, dependent: :restrict_with_exception
  has_many :users, dependent: :restrict_with_exception
  has_many :posts, dependent: :restrict_with_exception
  has_many :questions, dependent: :restrict_with_exception
  has_many :grains, dependent: :restrict_with_exception
  has_many :patterns, dependent: :restrict_with_exception
  has_many :comments, dependent: :restrict_with_exception
  has_many :user_languages, dependent: :restrict_with_exception
  has_many :dreams, dependent: :restrict_with_exception
  has_many :side_notes, dependent: :restrict_with_exception
end
