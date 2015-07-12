class Pattern < ActiveRecord::Base
  include HasLanguage
  include HasTrace
  include HasOwner
  include HasNameWithSlug

  belongs_to :user
  has_many :grains, dependent: :nullify

  validates_uniqueness_of :slug, scope: :language_id
end
