require 'rails_helper'

RSpec.describe IndexController, type: :controller do
  describe 'get index' do
    it 'returns successful response' do
      get :index
      expect(response).to be_success
    end
  end
end
