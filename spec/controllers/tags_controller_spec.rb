require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  let(:user) { create :administrator }
  let!(:tag) { create :tag }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns tag to @entity' do
      expect(assigns[:entity]).to eq(tag)
    end
  end

  describe 'get index' do
    before(:each) do
      get :index
    end

    it_behaves_like 'administrative_page'

    it 'assigns list of tags to @collection' do
      expect(assigns[:collection]).to include(tag)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'administrative_page'

    it 'assigns new instance Tag to @entity' do
      expect(assigns[:entity]).to be_a_new(Tag)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, tag: attributes_for(:tag) } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

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
    before(:each) { get :show, id: tag }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: tag }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: tag, tag: { name: 'new name' }
    end

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'updates tag' do
      tag.reload
      expect(tag.name).to eq('new name')
    end

    it 'redirects to tag page' do
      expect(response).to redirect_to(tag)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: tag } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

      it 'redirects to tags page' do
        expect(response).to redirect_to(tags_path)
      end
    end

    it 'removes tag from database' do
      expect(action).to change(Tag, :count).by(-1)
    end
  end
end
