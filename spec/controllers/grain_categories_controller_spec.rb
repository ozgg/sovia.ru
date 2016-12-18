require 'rails_helper'

RSpec.describe GrainCategoriesController, type: :controller do
  let!(:entity) { create :grain_category }
  let(:required_roles) { :administrator }
  let(:valid_create_params) { { grain_category: attributes_for(:grain_category) } }
  let(:valid_update_params) { { id: entity.id, grain_category: { name: 'changed' } } }
  let(:invalid_create_params) { { grain_category: { name: ' ' } } }
  let(:invalid_update_params) { { id: entity.id, grain_category: { name: ' ' } } }
  let(:path_after_create) { admin_grain_category_path(entity.class.last.id) }
  let(:path_after_update) { admin_grain_category_path(entity.id) }
  let(:path_after_destroy) { admin_grain_categories_path }

  it_behaves_like 'new_entity_with_required_roles'
  it_behaves_like 'create_entity_with_required_roles'
  it_behaves_like 'edit_lockable_entity_with_required_roles'
  it_behaves_like 'update_lockable_entity_with_required_roles'
  it_behaves_like 'delete_lockable_entity_with_required_roles'
end
