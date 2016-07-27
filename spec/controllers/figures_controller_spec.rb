require 'rails_helper'

RSpec.describe FiguresController, type: :controller do
  let(:user) { create :chief_editor }
  let!(:entity) { create :figure }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(subject).to receive(:restrict_editing)
    allow(Figure).to receive(:find).and_call_original
  end

  shared_examples 'restricted_editing' do
    it 'calls #restrict_editing' do
      expect(subject).to have_received(:restrict_editing)
    end
  end

  describe 'get show' do
    before :each do
      get :show, params: { id: entity }
    end

    it_behaves_like 'page_for_editors'
    it_behaves_like 'successful_response'
    it_behaves_like 'entity_finder'
  end

  describe 'get edit' do
    before :each do
      get :edit, params: { id: entity }
    end

    it_behaves_like 'page_for_editors'
    it_behaves_like 'restricted_editing'
    it_behaves_like 'successful_response'
    it_behaves_like 'entity_finder'
  end

  describe 'patch update' do
    before :each do
      patch :update, params: { id: entity, figure: { alt_text: 'changed' } }
    end

    it_behaves_like 'page_for_editors'
    it_behaves_like 'restricted_editing'
    it_behaves_like 'entity_finder'

    it 'updates figure' do
      entity.reload
      expect(entity.alt_text).to eq('changed')
    end

    it 'redirects to post page' do
      expect(response).to redirect_to(entity.post)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, params: { id: entity } } }

    context 'access, entity and redirect' do
      before :each do
        action.call
      end

      it_behaves_like 'page_for_editors'
      it_behaves_like 'restricted_editing'
      it_behaves_like 'entity_finder'

      it 'redirects to post page' do
        expect(response).to redirect_to(entity.post)
      end
    end

    context 'database change' do
      it 'removes figure from database' do
        expect(action).to change(Figure, :count).by(-1)
      end
    end
  end
end
