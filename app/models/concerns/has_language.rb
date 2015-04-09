module HasLanguage
  extend ActiveSupport::Concern

  included do
    belongs_to :language

    validates_presence_of :language
  end

  module ClassMethods
    # Find content in languages suitable for visitor
    def suitable_for(visitor)
      language_ids = Language.guess_from_locale
      language_ids << visitor.language_ids if visitor.respond_to?(:language_ids)
      self.where(language_id: [language_ids])
    end
  end

  # Get locale code for object
  #
  # Returns language code of locale or nil for default locale
  #
  # @return [String]
  def locale
    language_code = language.code
    (I18n.default_locale.to_s == language_code.to_s) ? nil : language_code
  end

end