class Grain < ActiveRecord::Base
  include HasLanguage
  include HasOwner
  include HasNameWithSlug

  belongs_to :user
  belongs_to :pattern

  validates_presence_of :user_id
  validates_uniqueness_of :slug, scope: [:user_id, :language_id]
end
