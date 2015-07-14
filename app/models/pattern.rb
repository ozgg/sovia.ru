class Pattern < ActiveRecord::Base
  include HasLanguage
  include HasTrace
  include HasOwner
  include HasNameWithSlug

  belongs_to :user
  has_many :grains, dependent: :nullify
  has_many :dream_patterns, dependent: :destroy
  has_many :dreams, through: :dream_patterns
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :pattern_links, dependent: :destroy

  validates_uniqueness_of :slug, scope: :language_id
end
