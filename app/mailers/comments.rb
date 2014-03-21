class Comments < ActionMailer::Base
  helper ApplicationHelper

  def entry_reply(comment)
    @comment = comment

    mail to: comment.entry.user.email
  end

  def comment_reply(comment)
    @comment = comment

    mail to: comment.parent.user.email
  end
end
