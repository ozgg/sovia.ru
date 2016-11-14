require 'rails_helper'

RSpec.describe Api::PatternsController, type: :controller do
  let(:user) { create :chief_interpreter }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'post toggle' do
    before(:each) { post :toggle, params: { id: entity, parameter: :described } }

    context 'when entity is not locked' do
      let(:entity) { create :pattern }

      it_behaves_like 'page_for_interpreters'
      it_behaves_like 'http_success'

      it 'toggles parameters' do
        entity.reload
        expect(entity).to be_described
      end
    end

    context 'when entity is locked' do
      let(:entity) { create :pattern, locked: true }

      it_behaves_like 'page_for_interpreters'
      it_behaves_like 'http_forbidden'

      it 'does not toggle parameter' do
        entity.reload
        expect(entity).not_to be_described
      end
    end
  end

  describe 'put lock' do
    let(:entity) { create :pattern }

    before :each do
      put :lock, params: { id: entity }
    end

    it_behaves_like 'page_for_chief_interpreter'
    it_behaves_like 'entity_locker'
  end

  describe 'delete unlock' do
    let(:entity) { create :pattern, locked: true }

    before :each do
      delete :unlock, params: { id: entity }
    end

    it_behaves_like 'page_for_chief_interpreter'
    it_behaves_like 'entity_unlocker'
  end

  describe 'patch update' do
    pending
  end

  describe 'delete destroy' do
    pending
  end
end
