module HasNameWithSlug
  extend ActiveSupport::Concern

  included do
    validates_presence_of :name, :slug

    before_validation :normalize_name, :generate_slug
  end

  module ClassMethods
    def match_by_name(name, language)
      find_by slug: Canonizer.canonize(name), language: language
    end

    def match_or_create_by_name(name, language)
      entity = find_by slug: Canonizer.canonize(name), language: language
      entity || create(name: name, language: language)
    end
  end

  protected

  def normalize_name
    self.name = self.name.squish[0..49]
  end

  def generate_slug
    self.slug = Canonizer.canonize self.name
  end
end
