class Comments < ActionMailer::Base
  def entry_reply(comment)
    @comment = comment

    mail to: comment.entry.user.email
  end
end
