require 'rails_helper'

RSpec.describe IndexController, type: :controller do
  describe 'get index' do
    it 'returns HTTP OK' do
      get :index
      expect(response.status).to eq(200)
    end
  end
end
