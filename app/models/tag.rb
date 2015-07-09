class Tag < ActiveRecord::Base
  include HasLanguage

  validates_presence_of :name, :slug
  validates_uniqueness_of :slug, scope: [:language]

  before_validation :normalize_name, :generate_slug

  protected

  def normalize_name
    self.name.squish!
  end

  def generate_slug
    self.slug = Canonizer.canonize self.name
  end
end
