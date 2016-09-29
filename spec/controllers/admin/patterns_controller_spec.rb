require 'rails_helper'

RSpec.describe Admin::PatternsController, type: :controller do
  let!(:entity) { create :pattern }

  before :each do
    allow(subject).to receive(:require_role)
  end

  it_behaves_like 'list_for_interpreters'

  describe 'get show' do
    let(:user) { create :chief_interpreter }

    before :each do
      allow(entity.class).to receive(:find).and_call_original
      get :show, params: { id: entity }
    end

    it_behaves_like 'page_for_interpreters'
    it_behaves_like 'entity_finder'
  end

  describe 'get dreams' do
    before :each do
      allow(Dream).to receive(:page_for_administration)
      get :dreams, params: { id: entity }
    end

    it_behaves_like 'page_for_interpreters'
    it_behaves_like 'http_success'

    it 'sends :page_for_administration to Dream' do
      expect(Dream).to have_received(:page_for_administration)
    end
  end
end
