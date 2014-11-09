class CommentsController < ApplicationController
  def index
    max_privacy = current_user.nil? ? Entry::PRIVACY_NONE : Entry::PRIVACY_USERS

    @comments = Comment.joins(:entry).where("entries.privacy <= #{max_privacy}").order('id desc').page(params[:page] || 1).per(5)
  end

  def new
  end

  def create
    @comment = Comment.new(comment_params)
    check_rights
    if suspect_spam?(@comment.user, @comment.body)
      redirect_with_confirmation
    else
      save_comment
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :entry_id, :parent_id).merge(user: current_user)
  end

  def check_rights
    entry = @comment.entry
    raise ForbiddenException unless entry.nil? || entry.visible_to?(current_user)
    unless @comment.parent.nil?
      parent = @comment.parent
      raise ForbiddenException unless parent.entry_id == @comment.entry_id
    end
  end

  def save_comment
    if @comment.save
      Comments.entry_reply(@comment).deliver if @comment.notify_entry_owner?
      Comments.comment_reply(@comment).deliver if @comment.notify_parent_owner?
      redirect_with_confirmation
    else
      render action: :new
    end
  end

  def redirect_with_confirmation
    flash[:notice] = t('comment.created')
    redirect_to view_context.verbose_entry_path(@comment.entry)
  end
end
