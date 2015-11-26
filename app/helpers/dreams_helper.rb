module DreamsHelper
  def dream_privacy_options
    prefix = 'activerecord.attributes.dream.privacies'
    Dream.privacies.keys.to_a.map { |privacy| [ I18n.t("#{prefix}.#{privacy}"), privacy ] }
  end

  def body_positions_for_select
    prefix = 'activerecord.attributes.dream.body_positions'
    [[t(:not_set), '']] + Dream.body_positions.keys.to_a.map { |position| [t("#{prefix}.#{position}"), position] }
  end
end
