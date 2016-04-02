require 'rails_helper'

RSpec.describe BrowsersController, type: :controller do
  let(:user) { create :administrator }
  let!(:entity) { create :browser }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns browser to @entity' do
      expect(assigns[:entity]).to eq(entity)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_administrator'

    it 'assigns list of browsers to @collection' do
      expect(assigns[:collection]).to include(entity)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'

    it 'assigns new instance of Browser to @entity' do
      expect(assigns[:entity]).to be_a_new(Browser)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, browser: attributes_for(:browser) } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_administrator'

      it 'redirects to created browser' do
        expect(response).to redirect_to(Browser.last)
      end
    end

    context 'database change' do
      it 'inserts row into browsers table' do
        expect(action).to change(Browser, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: entity }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: entity }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: entity, browser: { name: 'new text' }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'updates browser' do
      entity.reload
      expect(entity.name).to eq('new text')
    end

    it 'redirects to browser page' do
      expect(response).to redirect_to(entity)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: entity } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'page_for_administrator'

      it 'redirects to browsers page' do
        expect(response).to redirect_to(browsers_path)
      end
    end

    it 'removes browser from database' do
      expect(action).to change(Browser, :count).by(-1)
    end
  end

  describe 'post toggle' do
    it 'inverts present togglable attributes'
    it 'leaves absent togglable attributes intact'
    it 'returns JSON with new values'
  end
end
