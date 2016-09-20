require 'rails_helper'

RSpec.describe Api::AgentsController, type: :controller do
  let(:user) { create :administrator }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(Agent).to receive(:page_for_administration)
    allow(Agent).to receive(:find).and_call_original
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_administrator'

    it 'calls Agent::page_for_administration' do
      expect(Agent).to have_received(:page_for_administration)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, params: { id: entity, agent: { name: 'changed' } }
    end

    context 'when entity is not locked' do
      let(:entity) { create :agent }

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'entity_finder'
      it_behaves_like 'http_success'

      it 'updates agent' do
        entity.reload
        expect(entity.name).to eq('changed')
      end
    end

    context 'when entity is locked' do
      let(:entity) { create :agent, locked: true }

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'http_forbidden'

      it 'does not update agent' do
        entity.reload
        expect(entity.name).not_to eq('changed')
      end
    end
  end

  describe 'post toggle' do
    before(:each) { post :toggle, params: { id: entity, parameter: :mobile } }

    context 'when entity is not locked' do
      let(:entity) { create :agent }

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'http_success'

      it 'toggles parameters' do
        entity.reload
        expect(entity).to be_mobile
      end
    end

    context 'when entity is locked' do
      let(:entity) { create :agent, locked: true }

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'http_forbidden'

      it 'does not toggle parameter' do
        entity.reload
        expect(entity).not_to be_mobile
      end
    end
  end

  describe 'put lock' do
    let(:entity) { create :agent }

    before :each do
      put :lock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_locker'
  end

  describe 'delete unlock' do
    let(:entity) { create :agent, locked: true }

    before :each do
      delete :unlock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_unlocker'
  end
end
