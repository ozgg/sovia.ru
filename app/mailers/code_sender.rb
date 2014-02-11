class CodeSender < ActionMailer::Base
  default from: 'support@sovia.ru'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.code_sender.email.subject
  #
  def email
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.code_sender.password.subject
  #
  def password(code)
    @greeting = "Hi"

    mail to: code.user.email
  end
end
