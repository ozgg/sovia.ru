class Admin::CommentsController < ApplicationController
  before_action { |c| c.demand_role(User::ROLE_MODERATOR) }
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @comments = Comment.order(id: :desc).page(params[:page] || 1).per(10)
  end

  def show
  end

  def edit
  end

  def update
    if @comment.update(comment_parameters)
      flash[:notice] = t('comment.updated')
      redirect_to admin_comment_path(id: @comment)
    else
      render action: :edit
    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = t('comment.deleted')
    end
    redirect_to admin_comments_path
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_parameters
    params.require(:comment).permit(:body)
  end
end
