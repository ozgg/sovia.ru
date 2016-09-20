require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:current_user) { create :administrator }
  let!(:entity) { create :user }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(current_user)
    allow(entity.class).to receive(:with_long_slug).and_return(entity)
    allow(entity.class).to receive(:find).and_call_original
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'http_success'
  end

  describe 'post create' do
    context 'when parameters are valid' do
      let(:action) { -> { post :create, params: { user: attributes_for(:user).merge(network: 'native') } } }

      it_behaves_like 'entity_creator'

      context 'authorization and redirects' do
        before :each do
          action.call
        end

        it_behaves_like 'page_for_administrator'

        it 'redirects to created entity' do
          expect(response).to redirect_to(admin_user_path(entity.class.last))
        end
      end
    end

    context 'when parameters are invalid' do
      let(:action) { -> { post :create, params: { user: { slug: ' ' } } } }

      it_behaves_like 'entity_constant_count'

      context 'response' do
        before :each do
          action.call
        end

        it_behaves_like 'page_for_administrator'
        it_behaves_like 'http_bad_request'
      end
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, params: { id: entity } }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'
    it_behaves_like 'http_success'
  end

  describe 'patch update' do
    context 'when parameters are valid' do
      before(:each) do
        patch :update, params: { id: entity, user: { name: 'changed' } }
      end

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'entity_finder'

      it 'updates entity' do
        entity.reload
        expect(entity.name).to eq('changed')
      end

      it 'redirects to entity page' do
        expect(response).to redirect_to(admin_user_path(entity))
      end
    end

    context 'when parameters are invalid' do
      before :each do
        patch :update, params: { id: entity, user: { email: 'invalid' } }
      end

      it_behaves_like 'http_bad_request'

      it 'does not change entity' do
        entity.reload
        expect(entity.email).not_to eq('invalid')
      end
    end
  end

  describe 'delete destroy' do
    before :each do
      delete :destroy, params: { id: entity }
    end

    it_behaves_like 'entity_deleter'

    context 'authorization' do
      it_behaves_like 'page_for_administrator'

      it 'redirects to administrative entities page' do
        expect(response).to redirect_to(admin_users_path)
      end
    end
  end
end
