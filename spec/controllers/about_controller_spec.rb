require 'rails_helper'

RSpec.describe AboutController, type: :controller do
  describe 'get index' do
    before :each do
      get :index
    end

    it_behaves_like 'http_success'
  end

  describe 'get tos' do
    before :each do
      get :tos
    end

    it_behaves_like 'http_success'
  end
end
