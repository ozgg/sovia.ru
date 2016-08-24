# Preview all emails at http://localhost:3000/rails/mailers/comments
class CommentsPreview < ActionMailer::Preview
  def entry_reply
    Comments.entry_reply(Comment.last)
  end
end
