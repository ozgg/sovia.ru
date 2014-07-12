class ThoughtsController < ApplicationController
  before_action :set_thought, only: [:show, :edit, :update, :destroy]
  before_action :restrict_anonymous_access, only: [:new, :create, :edit, :update, :destroy]
  before_action :restrict_editor_access, only: [:edit, :update, :destroy]

  # get /thoughts
  def index
    @entries = allowed_thoughts.page(params[:page] || 1).per(5)
  end

  # get /thoughts/new
  def new
    @entry = Entry::Thought.new
  end

  # post /thoughts
  def create
    @entry = Entry::Thought.new(thought_parameters.merge(user: current_user))
    if suspect_spam?(current_user, @entry.body, 2)
      emulate_saving
    else
      create_thought
    end
  end

  # get /thoughts/:id
  def show
  end

  # get /thoughts/:id/edit
  def edit
  end

  # patch /thoughts/:id
  def update
    if @entry.update(thought_parameters)
      flash[:notice] = t('entry.thought.updated')
      redirect_to verbose_entry_thoughts_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: :edit
    end
  end

  # delete /thoughts/:id
  def destroy
    @entry.destroy
    flash[:notice] = t('entry.thought.deleted')
    redirect_to entry_thoughts_path
  end

  # get /thoughts/tagged/:tag
  def tagged
    @entries = tagged_thoughts.page(params[:page] || 1).per(5)
  end

  private

  def set_thought
    @entry = Entry::Thought.find(params[:id])
    raise UnauthorizedException unless @entry.visible_to? current_user
  end

  def thought_parameters
    params.require(:entry_thought).permit(:title, :body, :privacy, :tags_string)
  end

  def restrict_anonymous_access
    raise UnauthorizedException if current_user.nil?
  end

  def restrict_editor_access
    raise UnauthorizedException unless @entry.editable_by? current_user
  end

  def allowed_thoughts
    maximal_privacy = current_user.nil? ? Entry::PRIVACY_NONE : Entry::PRIVACY_USERS

    Entry::Thought.recent.where("privacy <= #{maximal_privacy}")
  end

  def emulate_saving
    flash[:notice] = t('entry.thought.created')
    redirect_to entry_thoughts_path
  end

  def create_thought
    if @entry.save
      flash[:notice] = t('entry.thought.created')
      redirect_to verbose_entry_thoughts_path(id: @entry.id, uri_title: @entry.url_title)
    else
      render action: :new
    end
  end

  def tagged_thoughts
    @tag = Tag::Thought.match_by_name(params[:tag])
    raise record_not_found if @tag.nil?

    allowed_thoughts.joins(:entry_tags).where(entry_tags: { tag: @tag })
  end
end
