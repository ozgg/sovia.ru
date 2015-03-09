class Language < ActiveRecord::Base
  validates_presence_of :code, :name
  validates_uniqueness_of :code

  def self.locale_for_user(user)
    if user.is_a?(User) && user.language
      user_locale = user.language.code
      I18n.locale_available?(user_locale) ? user_locale : nil
    end
  end

  def self.guess_from_locale
    self.find_by_code I18n.locale
  end

  def i18n_name
    I18n.t("language.names.#{name}", default: :'language.names.no_translation')
  end
end
