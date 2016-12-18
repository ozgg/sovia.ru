require 'rails_helper'

RSpec.describe My::GrainsController, type: :controller do
  let(:user) { create :user }
  let!(:entity) { create :grain, user: user }

  before :each do
    allow(subject).to receive(:current_user).and_return(user)
    allow(subject).to receive(:restrict_anonymous_access)
  end

  describe 'get index' do
    before :each do
      allow(Grain).to receive(:page_for_owner)
      get :index
    end

    it_behaves_like 'page_for_user'

    it 'sends :page_for_owner to Grain' do
      expect(Grain).to have_received(:page_for_owner).with(user, 1)
    end
  end

  describe 'get show' do
    let(:action) { -> { get :show, params: { id: entity } } }

    before :each do
      expect(entity.class).to receive(:owned_by).and_call_original
      allow(entity.class).to receive(:find_by).and_return(entity)
    end

    context 'when grain is owned by user' do
      let(:entity) { create :grain, user: user }

      before :each do
        action.call
      end

      it_behaves_like 'entity_finder'
      it_behaves_like 'http_success'
    end
  end

  describe 'get dreams' do
    pending
  end
end
