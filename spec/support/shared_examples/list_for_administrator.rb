require 'rails_helper'

RSpec.shared_examples_for 'list_for_administrator' do
  describe 'get index' do
    let(:user) { create :administrator }

    before :each do
      allow(subject).to receive(:require_role)
      allow(subject).to receive(:current_user).and_return(user)
      get :index
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'collection_assigner'
  end
end
