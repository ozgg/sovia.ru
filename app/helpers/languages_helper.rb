module LanguagesHelper
  # List of languages for options_for_select
  #
  # @return [Array]
  def languages_for_select
    Language.all.map { |language| [language_name(language), language.id] }
  end

  # Get I18n language name
  #
  # @param [Language] language
  # @return [String]
  def language_name(language)
    I18n.t("languages.#{language.slug}.name", default: language.slug)
  end
end
