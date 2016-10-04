module QuestionsHelper
  # @param [Question] question
  # @param [String] text
  # @param [Hash] options
  def question_link(question, text = nil, options = {})
    text ||= "#{t('activerecord.models.question')} #{question.id}"
    link_to text, question_path({ id: question.id }.merge(options))
  end

  # @param [Question] question
  def admin_question_link(question)
    link_to "#{t('activerecord.models.question')} #{question.id}", admin_question_path(question.id)
  end
end
