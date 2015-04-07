require 'rails_helper'

RSpec.describe My::DeedsController, type: :controller do
  let(:user) { create :unconfirmed_user }
  let!(:deed) { create :deed, user: user }
  let!(:other_deed) { create :deed }

  describe 'get index' do
    before :each do
      allow(controller).to receive(:allow_authorized_only)
      session[:user_id] = user.id
      get :index
    end

    it 'assigns @deeds with deed of current user' do
      expect(assigns[:deeds]).to include(deed)
    end

    it 'assigns @deeds without deed of other users' do
      expect(assigns[:deeds]).not_to include(other_deed)
    end

    it 'allows authorized users only' do
      expect(controller).to have_received(:allow_authorized_only)
    end
  end
end
