module PatternsHelper
  def link_to_dreambook(pattern)
    link_to pattern.name, dreambook_word_path(letter: pattern.letter, word: pattern.name_for_url)
  end

  def grain_categories_for_select
    prefix = 'activerecord.attributes.grain.categories'
    [[I18n.t(:not_set), '']] + Grain.categories.keys.map { |c| [I18n.t("#{prefix}.#{c}"), c] }
  end
end
