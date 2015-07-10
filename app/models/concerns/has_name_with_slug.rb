module HasNameWithSlug
  extend ActiveSupport::Concern

  included do
    validates_presence_of :name, :slug

    before_validation :normalize_name, :generate_slug
  end

  module ClassMethods
  end

  protected

  def normalize_name
    self.name = self.name.squish[0..49]
  end

  def generate_slug
    self.slug = Canonizer.canonize self.name
  end
end
