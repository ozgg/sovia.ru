require 'rails_helper'

RSpec.shared_examples_for 'list_for_visitors' do
  describe 'get index' do
    before :each do
      allow(subject).to receive(:current_user).and_return(user)
      allow(subject).to receive(:require_role)
      allow(entity.class).to receive(:page_for_visitors)
      get :index
    end

    it_behaves_like 'page_for_everybody'
    it_behaves_like 'http_success'

    it 'sends :page_for_visitors to entity class' do
      expect(entity.class).to have_received(:page_for_visitors)
    end
  end
end
