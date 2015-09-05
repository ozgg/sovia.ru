require 'rails_helper'

RSpec.describe AboutController, type: :controller do
  shared_examples 'response_is_ok' do
    it 'responds with code 200' do
      expect(response).to be_success
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'response_is_ok'
  end

  describe 'get features' do
    before(:each) { get :features }

    it_behaves_like 'response_is_ok'
  end

  describe 'get terms_of_service' do
    before(:each) { get :terms_of_service }

    it_behaves_like 'response_is_ok'
  end

  describe 'get privacy' do
    before(:each) { get :privacy }

    it_behaves_like 'response_is_ok'
  end
end
