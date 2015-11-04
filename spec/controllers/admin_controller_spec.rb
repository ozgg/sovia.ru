require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  describe "GET #index" do
    before(:each) do
      allow(controller).to receive(:require_role)
      get :index
    end

    it_behaves_like 'administrative_page'

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
