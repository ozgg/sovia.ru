class Tag < ActiveRecord::Base
  include HasLanguage
  include HasNameWithSlug

  validates_uniqueness_of :slug, scope: [:language]
end
