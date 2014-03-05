class CommentsController < ApplicationController
  def new
  end

  def create
    @comment = Comment.new(comment_params)
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
    raise ForbiddenException unless @comment.visible_to?(current_user)
  end
end
