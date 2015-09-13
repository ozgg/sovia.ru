class Comments < ApplicationMailer
  helper CommentsHelper

  def entry_reply(comment)
    @comment = comment

    mail to: comment.commentable.user.email
  end

  def comment_reply(comment)
    @comment = comment

    mail to: comment.parent.user.email
  end
end