require 'rails_helper'

RSpec.describe CodesController, type: :controller do
  let!(:entity) { create :code }
  let(:required_roles) { [:administrator] }
  let(:code_params) { { category: Code.categories.keys.first, user_id: create(:user).id } }
  let(:valid_create_params) { { code: attributes_for(:code).merge(code_params) } }
  let(:valid_update_params) { { id: entity.id, code: { payload: 'Changed' } } }
  let(:invalid_create_params) { { code: { body: ' ' } } }
  let(:invalid_update_params) { { id: entity.id, code: { body: ' ' } } }
  let(:path_after_create) { admin_code_path(entity.class.last.id) }
  let(:path_after_update) { admin_code_path(entity.id) }
  let(:path_after_destroy) { admin_codes_path }

  before :each do
    allow(subject).to receive(:require_role)
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  it_behaves_like 'new_entity_with_required_roles'
  it_behaves_like 'create_entity_with_required_roles'
  it_behaves_like 'edit_entity_with_required_roles'
  it_behaves_like 'update_entity_with_required_roles'
  it_behaves_like 'destroy_entity_with_required_roles'
end
