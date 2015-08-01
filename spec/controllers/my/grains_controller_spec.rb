require 'rails_helper'

RSpec.describe My::GrainsController, type: :controller do
  let(:user) { create :user }
  let!(:grain) { create :grain, user: user }
  let!(:foreign_grain) { create :grain }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it 'includes grains of user into @collection' do
      expect(assigns[:collection]).to include(grain)
    end

    it 'does not include foreign grains into @collection' do
      expect(assigns[:collection]).not_to include(foreign_grain)
    end

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end
end
