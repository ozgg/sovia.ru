# frozen_string_literal: true

# Managing patterns
class PatternsController < AdminController
  before_action :set_entity, only: %i[edit update destroy]

  # post /patterns/check
  def check
    @entity = Pattern.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /patterns/new
  def new
    @entity = Pattern.new
  end

  # post /patterns
  def create
    @entity = Pattern.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_pattern_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /patterns/:id/edit
  def edit
  end

  # patch /patterns/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_pattern_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /patterns/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('patterns.destroy.success')
    end
    redirect_to(admin_patterns_path)
  end

  protected

  def restrict_access
    require_privilege :dreambook_manager
  end

  def set_entity
    @entity = Pattern.find_by(id: params[:id])
    handle_http_404('Cannot find pattern') if @entity.nil?
  end

  def entity_parameters
    params.require(:pattern).permit(Pattern.entity_parameters)
  end
end
