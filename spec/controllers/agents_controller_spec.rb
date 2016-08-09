require 'rails_helper'

RSpec.describe AgentsController, type: :controller do
  let(:user) { create :administrator }
  let!(:entity) { create :agent }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(Agent).to receive(:find).and_call_original
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'
  end

  describe 'post create' do
    let(:action) { -> { post :create, params: { agent: attributes_for(:agent) } } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_administrator'

      it 'redirects to created agent' do
        expect(response).to redirect_to(Agent.last)
      end
    end

    context 'database change' do
      it 'inserts row into agents table' do
        expect(action).to change(Agent, :count).by(1)
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
      patch :update, params: { id: entity, agent: { name: 'changed' } }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'

    it 'updates agent' do
      entity.reload
      expect(entity.name).to eq('changed')
    end

    it 'redirects to agent page' do
      expect(response).to redirect_to(entity)
    end
  end

  describe 'delete destroy' do
    before(:each) { delete :destroy, params: { id: entity } }

    it_behaves_like 'page_for_administrator'

    it 'redirects to agents page' do
      expect(response).to redirect_to(admin_agents_path)
    end

    it 'marks agent as deleted' do
      entity.reload
      expect(entity).to be_deleted
    end
  end
end
