module DreamsHelper
  def dream_privacy_options
    prefix = 'activerecord.attributes.dream.privacies'
    Dream.privacies.keys.to_a.map { |privacy| [ I18n.t("#{prefix}.#{privacy}"), privacy ] }
  end
end
