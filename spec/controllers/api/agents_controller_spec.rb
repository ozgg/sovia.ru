require 'rails_helper'

RSpec.describe Api::AgentsController, type: :controller do
  let!(:entity) { create :agent }
  let(:required_roles) { :administrator }

  before :each do
    allow(subject).to receive(:require_role)
    allow(entity.class).to receive(:page_for_administration)
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  it_behaves_like 'list_for_administration'

  describe 'patch update' do
    let(:action) { -> { patch :update, params: { id: entity, agent: { name: 'Changed' } } } }

    context 'when entity is not locked' do
      before :each do
        action.call
      end

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'entity_finder'
      it_behaves_like 'http_success'

      it 'updates agent' do
        entity.reload
        expect(entity.name).to eq('Changed')
      end
    end

    context 'when entity is locked' do
      before :each do
        allow(entity).to receive(:locked?).and_return(true)
        action.call
      end

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'http_forbidden'

      it 'does not update agent' do
        entity.reload
        expect(entity.name).not_to eq('changed')
      end
    end
  end

  describe 'post toggle' do
    let(:action) { -> { post :toggle, params: { id: entity, parameter: :mobile } } }

    context 'when entity is not locked' do
      before :each do
        action.call
      end

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'http_success'

      it 'toggles parameters' do
        entity.reload
        expect(entity).to be_mobile
      end
    end

    context 'when entity is locked' do
      before :each do
        allow(entity).to receive(:locked?).and_return(true)
        action.call
      end

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'http_forbidden'

      it 'does not toggle parameter' do
        entity.reload
        expect(entity).not_to be_mobile
      end
    end
  end

  describe 'put lock' do
    before :each do
      put :lock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_locker'
  end

  describe 'delete unlock' do
    before :each do
      entity.update! locked: false
      delete :unlock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_unlocker'
  end
end
