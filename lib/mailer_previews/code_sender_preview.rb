class CodeSenderPreview < ActionMailer::Preview
  def email
    CodeSender.email(Code.confirmation_for_user(User.first))
  end

  def password
    CodeSender.password(Code.recovery_for_user(User.first))
  end
end