require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  let!(:entity) { create :tag }
  let(:required_roles) { [:chief_editor, :editor] }
  let(:valid_create_params) { { tag: attributes_for(:tag) } }
  let(:valid_update_params) { { id: entity.id, tag: { name: 'changed' } } }
  let(:invalid_create_params) { { tag: { name: ' ' } } }
  let(:invalid_update_params) { { id: entity.id, tag: { name: ' ' } } }
  let(:path_after_create) { admin_tag_path(entity.class.last.id) }
  let(:path_after_update) { admin_tag_path(entity.id) }
  let(:path_after_destroy) { admin_tags_path }

  it_behaves_like 'index_entities_without_required_roles'
  it_behaves_like 'new_entity_with_required_roles'
  it_behaves_like 'create_entity_with_required_roles'
  it_behaves_like 'show_entity_without_required_roles'
  it_behaves_like 'edit_lockable_entity_with_required_roles'
  it_behaves_like 'update_lockable_entity_with_required_roles'
  it_behaves_like 'delete_lockable_entity_with_required_roles'
end
