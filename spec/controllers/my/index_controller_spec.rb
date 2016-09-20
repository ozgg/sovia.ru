require 'rails_helper'

RSpec.describe My::IndexController, type: :controller do
  let!(:user) { create :user }

  before :each do
    allow(subject).to receive(:restrict_anonymous_access)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_user'
    it_behaves_like 'http_success'
  end
end
