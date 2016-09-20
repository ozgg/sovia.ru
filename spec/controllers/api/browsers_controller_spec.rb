require 'rails_helper'

RSpec.describe Api::BrowsersController, type: :controller do
  let(:user) { create :administrator }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'post toggle' do
    before(:each) { post :toggle, params: { id: entity, parameter: :mobile } }

    context 'when entity is not locked' do
      let(:entity) { create :browser }

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'http_success'

      it 'toggles parameters' do
        entity.reload
        expect(entity).to be_mobile
      end
    end

    context 'when entity is locked' do
      let(:entity) { create :browser, locked: true }

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'http_forbidden'

      it 'does not toggle parameter' do
        entity.reload
        expect(entity).not_to be_mobile
      end
    end
  end

  describe 'put lock' do
    let(:entity) { create :browser }

    before :each do
      put :lock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_locker'
  end

  describe 'delete unlock' do
    let(:entity) { create :browser, locked: true }

    before :each do
      delete :unlock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_unlocker'
  end
end
