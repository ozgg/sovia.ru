class WordsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /words/new
  def new
    @entity = Word.new
  end

  # post /words
  def create
    @entity = Word.new entity_parameters
    if @entity.save
      set_dependent_entities
      redirect_to admin_word_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /words/:id/edit
  def edit
  end

  # patch /words/:id
  def update
    if @entity.update entity_parameters
      set_dependent_entities
      redirect_to admin_word_path(@entity), notice: t('words.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /words/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('words.destroy.success')
    end
    redirect_to admin_words_path
  end

  protected

  def restrict_access
    require_role :chief_interpreter, :interpreter
  end

  def set_entity
    @entity = Word.find params[:id]
  end

  def restrict_editing
    if @entity.locked?
      redirect_to admin_word_path(@entity), alert: t('words.edit.forbidden')
    end
  end

  def entity_parameters
    params.require(:word).permit(Word.entity_parameters)
  end

  def set_dependent_entities
    @entity.patterns_string = params[:patterns_string].to_s
  end
end
