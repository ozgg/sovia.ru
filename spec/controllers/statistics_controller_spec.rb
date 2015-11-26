require 'rails_helper'

RSpec.describe StatisticsController, type: :controller do
  describe 'get index' do
    it 'returns success' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'get patterns' do
    it 'assigns pattern to @collection' do
      pattern = create :pattern, dream_count: 1
      get :patterns
      expect(assigns[:collection]).to include(pattern)
    end
  end
end
