class Language < ActiveRecord::Base
  validates_presence_of :code, :name
  validates_uniqueness_of :code

  def i18n_name
    I18n.t("language.names.#{name}", default: :'language.names.no_translation')
  end
end
