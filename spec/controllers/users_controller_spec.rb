require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:entity) { create :user }
  let(:required_roles) { [:administrator] }
  let(:valid_create_params) { { user: attributes_for(:user).merge(network: 'native') } }
  let(:valid_update_params) { { id: entity.id, user: { name: 'Changed' } } }
  let(:invalid_create_params) { { user: { email: 'invalid' } } }
  let(:invalid_update_params) { { id: entity.id, user: { email: 'invalid' } } }
  let(:path_after_create) { admin_user_path(entity.class.last.id) }
  let(:path_after_update) { admin_user_path(entity.id) }
  let(:path_after_destroy) { admin_users_path }

  it_behaves_like 'new_entity_with_required_roles'
  it_behaves_like 'create_entity_with_required_roles'
  it_behaves_like 'edit_entity_with_required_roles'
  it_behaves_like 'update_entity_with_required_roles'
  it_behaves_like 'delete_entity_with_required_roles'
end
