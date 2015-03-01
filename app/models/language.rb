class Language < ActiveRecord::Base
  validates_presence_of :code, :name, :i18n_name
  validates_uniqueness_of :code

  def translated_name
    I18n.t("language.names.#{i18n_name}")
  end
end
