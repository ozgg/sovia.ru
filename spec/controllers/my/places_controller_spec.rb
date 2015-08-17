require 'rails_helper'

RSpec.describe My::PlacesController, type: :controller do
  let(:user) { create :user }
  let!(:place) { create :place, user: user }
  let!(:foreign_place) { create :place }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_users'

    it 'includes places of user into @collection' do
      expect(assigns[:collection]).to include(place)
    end

    it 'does not include foreign places into @collection' do
      expect(assigns[:collection]).not_to include(foreign_place)
    end

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end
end
