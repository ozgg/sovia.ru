class CommentPreview < ActionMailer::Preview
  def comment
    last_comment = User.first.comments.last
    Comments.comment_reply(last_comment.comments.new(commentable: last_comment.commentable, body: 'Lalala [[Дом]]'))
  end

  def entry_reply
    Comments.entry_reply(User.first.comments.last)
  end
end
