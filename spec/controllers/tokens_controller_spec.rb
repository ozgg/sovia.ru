require 'rails_helper'

RSpec.describe TokensController, type: :controller do
  let(:user) { create :administrator }
  let!(:entity) { create :token }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(entity.class).to receive(:find).and_call_original
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'
  end

  describe 'post create' do
    let(:params) { { token: attributes_for(:token).merge(user_id: user.id) } }
    let(:action) { -> { post :create, params: params } }

    it_behaves_like 'entity_creator'

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_administrator'

      it 'redirects to created entity' do
        expect(response).to redirect_to(admin_token_path(entity.class.last))
      end
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, params: { id: entity } }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'
  end

  describe 'patch update' do
    before(:each) do
      patch :update, params: { id: entity, token: { active: '0' } }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'

    it 'updates entity' do
      entity.reload
      expect(entity).not_to be_active
    end

    it 'redirects to entity administration page' do
      expect(response).to redirect_to(admin_token_path(entity))
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, params: { id: entity } } }

    it_behaves_like 'entity_destroyer'

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'page_for_administrator'

      it 'redirects to entities administration page' do
        expect(response).to redirect_to(admin_tokens_path)
      end
    end
  end
end
