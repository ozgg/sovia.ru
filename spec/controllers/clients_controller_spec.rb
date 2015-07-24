require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  let(:user) { create :administrator }
  let!(:client) { create :client }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns client to @entity' do
      expect(assigns[:entity]).to eq(client)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'administrative_page'

    it 'assigns list of clients to @collection' do
      expect(assigns[:collection]).to include(client)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'administrative_page'

    it 'assigns new instance Client to @entity' do
      expect(assigns[:entity]).to be_a_new(Client)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, client: attributes_for(:client) } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

      it 'redirects to created client' do
        expect(response).to redirect_to(Client.last)
      end
    end

    context 'database change' do
      it 'inserts row into clients table' do
        expect(action).to change(Client, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: client }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: client }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: client, client: { name: 'new name' }
    end

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'updates client' do
      client.reload
      expect(client.name).to eq('new name')
    end

    it 'redirects to client page' do
      expect(response).to redirect_to(client)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: client } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

      it 'redirects to clients page' do
        expect(response).to redirect_to(clients_path)
      end
    end

    it 'removes client from database' do
      expect(action).to change(Client, :count).by(-1)
    end
  end
end
