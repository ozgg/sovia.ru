# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/interpretation_notifier
class InterpretationNotifierPreview < ActionMailer::Preview
  def new_request
    InterpretationMailer.new_request(Interpretation.last.id)
  end

  def new_message_from_user
    id = InterpretationMessage.where(from_user: true).last.id
    InterpretationMailer.new_message_from_user(id)
  end

  def new_message_from_interpreter
    id = InterpretationMessage.where(from_user: false).last.id
    InterpretationMailer.new_message_from_interpreter(id)
  end
end
