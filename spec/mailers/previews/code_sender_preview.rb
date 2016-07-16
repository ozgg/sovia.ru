# Preview all emails at http://localhost:3000/rails/mailers/code_sender
class CodeSenderPreview < ActionMailer::Preview
  def password
    CodeSender.password(Code.recovery_for_user(User.first))
  end
end
