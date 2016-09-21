require 'rails_helper'

RSpec.shared_examples_for 'entity_for_administration' do
  describe 'get show' do
    let(:user) { create :administrator }

    before :each do
      allow(subject).to receive(:require_role)
      allow(subject).to receive(:current_user).and_return(user)
      allow(entity.class).to receive(:find).and_call_original
      get :show, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'
  end
end
