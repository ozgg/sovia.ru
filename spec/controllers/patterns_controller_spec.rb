require 'rails_helper'

RSpec.describe PatternsController, type: :controller do
  let!(:entity) { create :pattern }
  let(:required_roles) { [:chief_interpreter, :interpreter] }
  let(:valid_create_params) { { pattern: attributes_for(:pattern) } }
  let(:valid_update_params) { { id: entity.id, pattern: { name: 'changed' } } }
  let(:invalid_create_params) { { pattern: { name: ' ' } } }
  let(:invalid_update_params) { { id: entity.id, pattern: { name: ' ' } } }
  let(:path_after_create) { admin_pattern_path(entity.class.last.id) }
  let(:path_after_update) { admin_pattern_path(entity.id) }
  let(:path_after_destroy) { admin_patterns_path }

  it_behaves_like 'new_entity_with_required_roles'
  it_behaves_like 'create_entity_with_required_roles'
  it_behaves_like 'edit_lockable_entity_with_required_roles'
  it_behaves_like 'update_lockable_entity_with_required_roles'
  it_behaves_like 'delete_lockable_entity_with_required_roles'
end
