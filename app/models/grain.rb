class Grain < ActiveRecord::Base
  include HasLanguage
  include HasOwner
  include HasNameWithSlug

  belongs_to :user
  belongs_to :pattern
  has_many :dream_grains, dependent: :destroy
  has_many :dreams, through: :dream_grains

  validates_presence_of :user_id
  validates_uniqueness_of :slug, scope: [:user_id, :language_id]
end
