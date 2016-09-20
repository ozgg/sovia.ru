require 'rails_helper'

RSpec.describe Api::CommentsController, type: :controller do
  let(:user) { create :administrator }

  before :each do
    create :user_role, user: user, role: :moderator
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'post toggle' do
    before(:each) { post :toggle, params: { id: entity, parameter: :visible } }

    context 'when entity is not locked' do
      let(:entity) { create :comment }

      it_behaves_like 'page_for_moderators'
      it_behaves_like 'successful_response'

      it 'toggles parameters' do
        entity.reload
        expect(entity).not_to be_visible
      end
    end

    context 'when entity is locked' do
      let(:entity) { create :comment, locked: true }

      it_behaves_like 'page_for_moderators'
      it_behaves_like 'http_forbidden'

      it 'does not toggle parameter' do
        entity.reload
        expect(entity).to be_visible
      end
    end
  end

  describe 'put lock' do
    let(:entity) { create :comment }

    before :each do
      put :lock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_locker'
  end

  describe 'delete unlock' do
    let(:entity) { create :comment, locked: true }

    before :each do
      delete :unlock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_unlocker'
  end
end
