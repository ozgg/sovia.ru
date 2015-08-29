class CommentsController < ApplicationController
  before_action :restrict_access, except: [:create]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  def index
    @collection = Comment.in_languages(visitor_languages).order('id desc').page(current_page).per(25)
  end

  def new
    @entity = Comment.new
  end

  def create
    @entity = Comment.new creation_parameters
    if Trap.suspect_spam?(@entity.user, @entity.body, 2)
      add_violation
    else
      save_comment
    end
  end

  def show
  end

  def edit
  end

  def update
    if @entity.update entity_parameters
      redirect_to @entity, notice: t('comments.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @entity.destroy
      flash[:notice] = t('comments.destroy.success')
    end
    redirect_to comments_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Comment.find params[:id]
  end

  def entity_parameters
    parameters = params.require(:comment).permit(:commentable_id, :commentable_type, :parent_id, :best, :body)
    unless current_user_has_role? :administrator
      %i(visible best).each { |parameter| parameters.reject! parameter if parameters.include? parameter }
    end
    parameters
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity).merge(language_for_entity).merge(tracking_for_entity)
  end

  def add_violation
    parameters = { user: @entity.user, category: Violation.categories[:comments_spam], body: @entity.body }
    Violation.create(parameters.merge tracking_for_entity)

    redirect_with_confirmation
  end

  def save_comment
    if @entity.save
      notify_participants
      redirect_with_confirmation
    else
      render :new
    end
  end

  def redirect_with_confirmation
    flash[:notice] = t('comments.create.success')
    redirect_to(@entity.commentable || root_path)
  end

  def notify_participants
    # begin
    #   Comments.entry_reply(@comment).deliver if @comment.notify_entry_owner?
    #   Comments.comment_reply(@comment).deliver if @comment.notify_parent_owner?
    # rescue Net::SMTPAuthenticationError => e
    #   logger.warn e.message
    # end
  end
end
