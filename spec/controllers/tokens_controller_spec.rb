require 'rails_helper'

RSpec.describe TokensController, type: :controller do
  let!(:entity) { create :token }
  let(:required_roles) { [:administrator] }
  let(:valid_create_params) { { token: attributes_for(:token).merge(user_id: create(:user).id ) } }
  let(:valid_update_params) { { id: entity.id, token: { active: '0' } } }
  let(:invalid_create_params) { { token: { user_id: '' } } }
  let(:path_after_create) { admin_token_path(entity.class.last.id) }
  let(:path_after_update) { admin_token_path(entity.id) }
  let(:path_after_destroy) { admin_tokens_path }

  before :each do
    allow(subject).to receive(:require_role)
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  it_behaves_like 'new_entity_with_required_roles'
  it_behaves_like 'create_entity_with_required_roles'
  it_behaves_like 'edit_entity_with_required_roles'
  it_behaves_like 'destroy_entity_with_required_roles'

  describe 'patch update' do
    before :each do
      patch :update, params: valid_update_params
    end

    it_behaves_like 'required_roles'
    it_behaves_like 'entity_finder'

    it 'redirects to entity' do
      expect(response).to redirect_to(path_after_update)
    end
  end
end
