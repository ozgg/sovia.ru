require 'rails_helper'

RSpec.describe My::IndexController, type: :controller do
  let(:user) { create :user }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_users'

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end
end
