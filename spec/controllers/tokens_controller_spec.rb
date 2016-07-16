require 'rails_helper'

RSpec.describe TokensController, type: :controller do
  let(:user) { create :administrator }
  let!(:entity) { create :token }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(Token).to receive(:find).and_call_original
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'
  end

  describe 'post create' do
    let(:params) { { token: attributes_for(:token).merge(user_id: user.id) } }
    let(:action) { -> { post :create, params: params } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_administrator'

      it 'redirects to created token' do
        expect(response).to redirect_to(Token.last)
      end
    end

    context 'database change' do
      it 'inserts row into tokens table' do
        expect(action).to change(Token, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, params: { id: entity } }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'
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

    it 'updates token' do
      entity.reload
      expect(entity).not_to be_active
    end

    it 'redirects to token page' do
      expect(response).to redirect_to(entity)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, params: { id: entity } } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'page_for_administrator'

      it 'redirects to tokens page' do
        expect(response).to redirect_to(tokens_path)
      end
    end

    it 'removes token from database' do
      expect(action).to change(Token, :count).by(-1)
    end
  end
end
