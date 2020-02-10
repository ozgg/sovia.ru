# frozen_string_literal: true

# Creating, editing and destroying fillers
class FillersController < AdminController
  before_action :set_entity, only: %i[destroy edit update]

  # post /fillers/check
  def check
    @entity = Filler.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /fillers/new
  def new
    @entity = Filler.new
  end

  # post /fillers
  def create
    @entity = Filler.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_filler_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /fillers/:id/edit
  def edit
  end

  # patch /fillers/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_filler_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /fillers/:id
  def destroy
    flash[:notice] = t('fillers.destroy.success') if @entity.destroy

    redirect_to admin_fillers_path
  end

  protected

  def component_class
    Biovision::Components::DreamsComponent
  end

  def set_entity
    @entity = Filler.find_by(id: params[:id])
    handle_http_404("Cannot find filler #{params[:id]}") if @entity.nil?
  end

  def entity_parameters
    params.require(:filler).permit(Filler.entity_parameters)
  end
end
