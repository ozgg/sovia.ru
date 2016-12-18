require 'rails_helper'

RSpec.describe DreambookController, type: :controller do
  let!(:entity) { create :pattern }

  before :each do
    allow(subject).to receive(:require_role)
  end

  describe 'get index' do
    before :each do
      get :index
    end

    it_behaves_like 'no_roles_required'
    it_behaves_like 'http_success'
  end

  describe 'get word' do
    before :each do
      allow(entity.class).to receive(:match_by_name).and_call_original
    end

    context 'when pattern exists' do
      before :each do
        get :word, params: { word: entity.name }
      end

      it_behaves_like 'no_roles_required'
      it_behaves_like 'http_success'

      it 'sends :match_by_name to entity class' do
        expect(entity.class).to have_received(:match_by_name)
      end
    end

    context 'when pattern does not exist' do
      before :each do
        get :word, params: { word: 'non-existent' }
      end

      it_behaves_like 'no_roles_required'
      it_behaves_like 'http_not_found'
    end
  end

  describe 'get search' do
    it 'processes input with extractor'
  end
end
