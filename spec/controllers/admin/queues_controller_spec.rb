require 'rails_helper'

RSpec.describe Admin::QueuesController, :type => :controller do

  describe "GET tags" do
    it "returns http success" do
      get :tags
      expect(response).to have_http_status(:success)
    end
  end

end
