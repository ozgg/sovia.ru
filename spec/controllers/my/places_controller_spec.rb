require 'rails_helper'

RSpec.describe My::PlacesController, type: :controller do
  let(:user) { create :user }

  before :each do
    allow(subject).to receive(:current_user).and_return(user)
    allow(subject).to receive(:restrict_anonymous_access)
  end

  describe 'get index' do
    before :each do
      allow(Place).to receive(:page_for_owner)
      get :index
    end

    it_behaves_like 'page_for_user'

    it 'sends :page_for_owner to Place' do
      expect(Place).to have_received(:page_for_owner).with(user)
    end
  end

  describe 'get show' do
    let(:action) { -> { get :show, params: { id: entity } } }

    before :each do
      allow(Place).to receive(:find).and_call_original
    end

    context 'when place is owned by user' do
      let(:entity) { create :place, user: user }

      before :each do
        action.call
      end

      it_behaves_like 'entity_finder'
      it_behaves_like 'http_success'
    end

    context 'when entity is not owned by user' do
      let(:entity) { create :place }

      it_behaves_like 'record_not_found_exception'
    end
  end

  describe 'get dreams' do
    pending
  end
end
