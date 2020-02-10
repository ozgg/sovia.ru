# frozen_string_literal: true

# Notify about new dream interpretation requests
class InterpretationMailer < ApplicationMailer
  # @param [Integer] id
  def new_request(id)
    @entity = Interpretation.find_by(id: id)

    receiver = BiovisionComponent['contact'].settings['feedback_receiver']

    mail to: receiver unless @entity.nil? || receiver.blank?
  end

  # @param [Integer] id
  def new_message_from_user(id)
    @entity = InterpretationMessage.find_by(id: id)

    receiver = BiovisionComponent['contact'].settings['feedback_receiver']

    mail to: receiver unless @entity.nil? || receiver.blank?
  end

  # @param [Integer] id
  def new_message_from_interpreter(id)
    @entity = InterpretationMessage.find_by(id: id)

    receiver = @entity.user.email

    mail to: receiver unless @entity.nil? || receiver.blank?
  end
end
