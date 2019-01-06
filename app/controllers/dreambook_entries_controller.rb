# frozen_string_literal: true

# Managing legacy dreambook entries
class DreambookEntriesController < AdminController
  before_action :set_entity, only: %i[edit update destroy]

  # post /dreambook_entries/check
  def check
    @entity = DreambookEntry.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /dreambook_entries/new
  def new
    @entity = DreambookEntry.new
  end

  # post /dreambook_entries
  def create
    @entity = DreambookEntry.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_dreambook_entry_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /dreambook_entries/:id/edit
  def edit
  end

  # patch /dreambook_entries/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_dreambook_entry_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /dreambook_entries/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('dreambook_entries.destroy.success')
    end
    redirect_to(admin_dreambook_entries_path)
  end

  protected

  def restrict_access
    require_privilege :dreambook_manager
  end

  def set_entity
    @entity = DreambookEntry.find_by(id: params[:id])
    handle_http_404('Cannot find dreambook_entry') if @entity.nil?
  end

  def entity_parameters
    params.require(:dreambook_entry).permit(DreambookEntry.entity_parameters)
  end
end
