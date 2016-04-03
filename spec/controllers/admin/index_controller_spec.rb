require 'rails_helper'

RSpec.describe Admin::IndexController, type: :controller do
  let(:user) { create :administrator }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_administrator'
  end
end
