module HasNameWithSlug
  extend ActiveSupport::Concern

  included do
    validates_presence_of :name, :slug

    before_validation :normalize_name, :generate_slug
  end

  module ClassMethods
    def match_by_name(name)
      find_by slug: Canonizer.canonize(name)
    end

    def match_by_name!(name)
      result = match_by_name name
      raise ActiveRecord::RecordNotFound if result.nil?
      result
    end

    def match_or_create_by_name(name)
      entity = find_by slug: Canonizer.canonize(name)
      entity || create(name: name)
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
