class CommentsController < ApplicationController
  def new
  end

  def create
    @comment = Comment.new(comment_params)
    check_rights
    if @comment.save
      flash[:notice] = t('comment.created')
      redirect_to @comment.entry
    else
      render action: :new
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :entry_id).merge(user: current_user)
  end

  def check_rights
    entry = @comment.entry
    raise ForbiddenException unless entry.nil? || entry.visible_to?(current_user)
  end
end
