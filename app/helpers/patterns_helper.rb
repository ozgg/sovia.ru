module PatternsHelper
  # @param [Pattern] pattern
  # @param [User] text
  def pattern_link(pattern, text = pattern.name)
    link_to text, pattern
  end

  def grain_categories_for_select
    options = [[t(:not_selected), '']]
    GrainCategory.page_for_users.each { |c| options << [c.name, c.id] }
    options
  end

  # @param [Pattern] pattern
  def pattern_in_dreambook(pattern)
    link_to pattern.name, dreambook_word_path(word: pattern.name)
  end
end
