require 'rails_helper'

RSpec.describe Admin::WordsController, type: :controller do
  let!(:entity) { create :word }

  it_behaves_like 'list_for_interpreters'

  describe 'get show' do
    let(:user) { create :administrator }

    before :each do
      allow(subject).to receive(:require_role)
      allow(subject).to receive(:current_user).and_return(user)
      allow(entity.class).to receive(:find).and_call_original
      get :show, params: { id: entity }
    end

    it_behaves_like 'page_for_interpreters'
    it_behaves_like 'entity_finder'
  end

  describe 'get dreams' do
    pending
  end
end