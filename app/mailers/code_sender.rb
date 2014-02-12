class CodeSender < ActionMailer::Base
  default from: 'support@sovia.ru'

  def email(code)
    @code = code

    mail to: code.user.email
  end

  def password(code)
    @code = code

    mail to: code.user.email
  end
end
