class CommentsController < ApplicationController
  before_action :restrict_anonymous_access, except: [:create]
  before_action :restrict_access, except: [:create]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  # post /comments
  def create
    @entity = Comment.new creation_parameters
    save_if_not_spam
  end

  # get /comments/:id
  def show
    redirect_to @entity.commentable
  end

  # get /comments/:id/edit
  def edit
  end

  # patch /comments/:id
  def update
    if @entity.update entity_parameters
      redirect_to admin_comment_path(@entity), notice: t('comments.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /comments/:id
  def destroy
    if @entity.update deleted: true
      flash[:notice] = t('comments.destroy.success')
    end
    redirect_to(@entity.commentable || admin_comments_path)
  end

  private

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Comment.find params[:id]
  end

  def entity_parameters
    params.require(:comment).permit(Comment.entity_parameters)
  end

  def creation_parameters
    params.require(:comment).permit(Comment.creation_parameters).merge(owner_for_entity).merge(tracking_for_entity)
  end

  def notify_participants
    Comments.entry_reply(@entity).deliver_later if @entity.notify_entry_owner?
  end

  def save_if_not_spam
    if Violation.suspicious?(@entity.body)
      violation = Violation.new
      violation.use_entity(@entity)
      violation.save
      redirect_to(@entity.commentable || root_path, notice: t('comments.create.success'))
    else
      save_comment
    end
  end

  def save_comment
    if @entity.save
      notify_participants
      redirect_to(@entity.commentable || admin_comments_path, notice: t('comments.create.success'))
    else
      render :new, status: :bad_request
    end
  end
end
