require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  let(:user) { create :chief_editor }
  let!(:entity) { create :tag }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(Tag).to receive(:find).and_call_original
  end

  describe 'get index' do
    before :each do
      allow(Tag).to receive(:page_for_visitors).and_call_original
      get :index
    end

    it_behaves_like 'successful_response'

    it 'receives list of tags for visitors' do
      expect(Tag).to have_received(:page_for_visitors)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_editors'
  end

  describe 'post create' do
    let(:action) { -> { post :create, params: { tag: attributes_for(:tag) } } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_editors'

      it 'redirects to created tag' do
        expect(response).to redirect_to(Tag.last)
      end
    end

    context 'database change' do
      it 'inserts row into tags table' do
        expect(action).to change(Tag, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, params: { id: entity } }

    it_behaves_like 'page_for_editors'
    it_behaves_like 'entity_finder'
  end

  describe 'get edit' do
    before(:each) { get :edit, params: { id: entity } }

    it_behaves_like 'page_for_editors'
    it_behaves_like 'entity_finder'
  end

  describe 'patch update' do
    before(:each) do
      patch :update, params: { id: entity, tag: { name: 'changed' } }
    end

    it_behaves_like 'page_for_editors'
    it_behaves_like 'entity_finder'

    it 'updates tag' do
      entity.reload
      expect(entity.name).to eq('changed')
    end

    it 'redirects to tag page' do
      expect(response).to redirect_to(entity)
    end
  end

  describe 'delete destroy' do
    before(:each) { delete :destroy, params: { id: entity } }

    it_behaves_like 'page_for_editors'

    it 'redirects to tags page' do
      expect(response).to redirect_to(admin_tags_path)
    end

    it 'marks tag as deleted' do
      entity.reload
      expect(entity).to be_deleted
    end
  end
end
