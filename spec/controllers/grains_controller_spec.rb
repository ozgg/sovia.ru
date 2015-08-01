require 'rails_helper'

RSpec.describe GrainsController, type: :controller do
  let(:language) { create :russian_language }
  let(:user) { create :user, language: language }
  let!(:grain) { create :grain, user: user, language: language }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
    I18n.locale = language.code
  end

  shared_examples 'entity_assigner' do
    it 'assigns grain to @entity' do
      expect(assigns[:entity]).to eq(grain)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_users'

    it 'assigns new instance Grain to @entity' do
      expect(assigns[:entity]).to be_a_new(Grain)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, grain: attributes_for(:grain).merge(pattern: 'Pattern') } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_users'

      it 'redirects to created grain' do
        expect(response).to redirect_to(Grain.last)
      end
    end

    context 'database change' do
      it 'inserts row into grains table' do
        expect(action).to change(Grain, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: grain }

    it_behaves_like 'page_for_users'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: grain }

    it_behaves_like 'page_for_users'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: grain, grain: { name: 'new name' }
    end

    it_behaves_like 'page_for_users'
    it_behaves_like 'entity_assigner'

    it 'updates grain' do
      grain.reload
      expect(grain.name).to eq('new name')
    end

    it 'redirects to grain page' do
      expect(response).to redirect_to(grain)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: grain } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'page_for_users'

      it 'redirects to grains page' do
        expect(response).to redirect_to(my_grains_path)
      end
    end

    it 'removes grain from database' do
      expect(action).to change(Grain, :count).by(-1)
    end
  end
end
