require 'rails_helper'

RSpec.describe TokensController, type: :controller do
  let(:user) { create :administrator }
  let!(:token) { create :token }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns token to @entity' do
      expect(assigns[:entity]).to eq(token)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_administrator'

    it 'assigns list of tokens to @collection' do
      expect(assigns[:collection]).to include(token)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'

    it 'assigns new instance Token to @entity' do
      expect(assigns[:entity]).to be_a_new(Token)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, token: attributes_for(:token).merge(user_id: user.id) } }

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
    before(:each) { get :show, id: token }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: token }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: token, token: { active: '0' }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'updates token' do
      token.reload
      expect(token).not_to be_active
    end

    it 'redirects to token page' do
      expect(response).to redirect_to(token)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: token } }

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
