require 'rails_helper'

RSpec.describe My::DeedsController, type: :controller do
  let(:user) { create :user }
  let!(:deed) { create :deed, user: user }
  let!(:foreign_deed) { create :deed }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it 'includes deeds of user into @collection' do
      expect(assigns[:collection]).to include(deed)
    end

    it 'does not include foreign deeds into @collection' do
      expect(assigns[:collection]).not_to include(foreign_deed)
    end

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end
end
