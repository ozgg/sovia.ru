require 'rails_helper'

RSpec.describe AgentsController, type: :controller do
  let(:user) { create :administrator }
  let!(:agent) { create :agent }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns agent to @entity' do
      expect(assigns[:entity]).to eq(agent)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'administrative_page'

    it 'assigns list of agents to @collection' do
      expect(assigns[:collection]).to include(agent)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'administrative_page'

    it 'assigns new instance agent to @entity' do
      expect(assigns[:entity]).to be_a_new(Agent)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, agent: attributes_for(:agent) } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

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
    before(:each) { get :show, id: agent }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: agent }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: agent, agent: { name: 'new name' }
    end

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'updates agent' do
      agent.reload
      expect(agent.name).to eq('new name')
    end

    it 'redirects to agent page' do
      expect(response).to redirect_to(agent)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: agent } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

      it 'redirects to agents page' do
        expect(response).to redirect_to(agents_path)
      end
    end

    it 'removes agent from database' do
      expect(action).to change(Agent, :count).by(-1)
    end
  end
end
