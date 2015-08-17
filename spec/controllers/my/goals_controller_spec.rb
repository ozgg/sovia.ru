require 'rails_helper'

RSpec.describe My::GoalsController, type: :controller do
  let(:user) { create :user }
  let!(:goal) { create :goal, user: user }
  let!(:foreign_goal) { create :goal }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_users'

    it 'includes goals of user into @collection' do
      expect(assigns[:collection]).to include(goal)
    end

    it 'does not include foreign goals into @collection' do
      expect(assigns[:collection]).not_to include(foreign_goal)
    end

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end
end
