module HasLanguage
  extend ActiveSupport::Concern

  included do
    belongs_to :language

    validates_presence_of :language_id

    scope :in_languages, ->(language_ids) { where(language_id: language_ids) }
  end

  module ClassMethods
  end

  # Get locale code for object
  #
  # Returns language code of locale or nil for default locale
  #
  # @return [String]
  def locale
    language.code
  end
end
