require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:entity) { create :user }

  before :each do
    allow(entity.class).to receive(:find).and_call_original
    allow(subject).to receive(:require_role)
  end

  it_behaves_like 'list_for_administration'
  it_behaves_like 'entity_for_administration'

  describe 'get tokens' do
    before :each do
      allow(Token).to receive(:page_for_administration)
      allow(Token).to receive(:owned_by).and_call_original
      get :tokens, params: { id: entity }
    end

    it_behaves_like 'entity_finder'
    it_behaves_like 'page_for_administrator'
    it_behaves_like 'http_success'

    it 'filters tokens by ownership' do
      expect(Token).to have_received(:owned_by)
    end

    it 'sends :page_for_administration to Token' do
      expect(Token).to have_received(:page_for_administration)
    end
  end

  describe 'get codes' do
    before :each do
      allow(Code).to receive(:page_for_administration)
      allow(Code).to receive(:owned_by).and_call_original
      get :codes, params: { id: entity }
    end

    it_behaves_like 'entity_finder'
    it_behaves_like 'page_for_administrator'
    it_behaves_like 'http_success'

    it 'filters codes by ownership' do
      expect(Code).to have_received(:owned_by)
    end

    it 'sends :page_for_administration to Code' do
      expect(Code).to have_received(:page_for_administration)
    end
  end
end
