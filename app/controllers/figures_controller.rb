class FiguresController < ApplicationController
  before_action :restrict_access
  before_action :set_entity
  before_action :restrict_editing, except: [:show]

  # get /figures/:id
  def show
  end

  # get /figures/:id/edit
  def edit
  end

  # patch /figures/:id
  def update
    if @entity.update entity_parameters
      redirect_to @entity.post
    else
      render :edit, status: :bad_request
    end
  end

  # delete /figures/:id
  def destroy
    @entity.destroy
    redirect_to @entity.post
  end

  private

  def set_entity
    @entity = Figure.find params[:id]
  end

  def restrict_access
    require_role :chief_editor, :editor
  end

  def restrict_editing
    raise record_not_found unless @entity.editable_by? current_user
  end

  def entity_parameters
    params.require(:figure).permit(Figure.entity_parameters)
  end
end
