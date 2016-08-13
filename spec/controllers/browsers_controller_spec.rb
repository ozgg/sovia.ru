require 'rails_helper'

RSpec.describe BrowsersController, type: :controller do
  let(:user) { create :administrator }
  let!(:entity) { create :browser }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(Browser).to receive(:find).and_call_original
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'
  end

  describe 'post create' do
    let(:action) { -> { post :create, params: { browser: attributes_for(:browser) } } }

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
      patch :update, params: { id: entity, browser: { name: 'changed' } }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'

    it 'updates browser' do
      entity.reload
      expect(entity.name).to eq('changed')
    end

    it 'redirects to browser page' do
      expect(response).to redirect_to(entity)
    end
  end

  describe 'delete destroy' do
    before(:each) { delete :destroy, params: { id: entity } }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'

    it 'redirects to browsers page' do
      expect(response).to redirect_to(admin_browsers_path)
    end

    it 'marks browser as deleted' do
      entity.reload
      expect(entity).to be_deleted
    end
  end

  describe 'get agents' do
    before(:each) do
      allow(Agent).to receive(:page_for_administration)
      get :agents, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'

    it 'gets administrative page of agents' do
      expect(Agent).to have_received(:page_for_administration)
    end
  end
end
