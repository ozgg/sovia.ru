require 'rails_helper'

RSpec.describe PatternsController, type: :controller do
  let!(:language) { create :russian_language }
  let(:user) { create :administrator, language: language }
  let!(:pattern) { create :pattern, language: language }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(user)
    I18n.locale = language.code
  end

  shared_examples 'entity_assigner' do
    it 'assigns pattern to @entity' do
      expect(assigns[:entity]).to eq(pattern)
    end
  end

  describe 'get index' do
    before(:each) do
      allow(controller).to receive(:visitor_languages).and_return([pattern.language_id])
      get :index
    end

    it_behaves_like 'administrative_page'

    it 'assigns list of patterns to @collection' do
      expect(assigns[:collection]).to include(pattern)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'administrative_page'

    it 'assigns new instance Pattern to @entity' do
      expect(assigns[:entity]).to be_a_new(Pattern)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, pattern: attributes_for(:pattern) } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

      it 'redirects to created pattern' do
        expect(response).to redirect_to(Pattern.last)
      end
    end

    context 'database change' do
      it 'inserts row into patterns table' do
        expect(action).to change(Pattern, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: pattern }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: pattern }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: pattern, pattern: { name: 'new name', links: [see_also: 'foo'] }
    end

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'updates pattern' do
      pattern.reload
      expect(pattern.name).to eq('new name')
    end

    it 'redirects to pattern page' do
      expect(response).to redirect_to(pattern)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: pattern } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

      it 'redirects to patterns page' do
        expect(response).to redirect_to(patterns_path)
      end
    end

    it 'removes pattern from database' do
      expect(action).to change(Pattern, :count).by(-1)
    end
  end
end
