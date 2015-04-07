require 'rails_helper'

RSpec.describe My::GoalsController, type: :controller do
  let(:user) { create :unconfirmed_user }
  let!(:goal) { create :goal, user: user }
  let!(:other_goal) { create :goal }

  describe 'get index' do
    before :each do
      allow(controller).to receive(:allow_authorized_only)
      session[:user_id] = user.id
      get :index
    end

    it 'assigns @goals with goal of current user' do
      expect(assigns[:goals]).to include(goal)
    end

    it 'assigns @goals without goal of other users' do
      expect(assigns[:goals]).not_to include(other_goal)
    end

    it 'allows authorized users only' do
      expect(controller).to have_received(:allow_authorized_only)
    end
  end
end
