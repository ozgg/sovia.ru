require 'rails_helper'

RSpec.describe PlacesController, type: :controller do
  let(:user) { create :user }
  let!(:place) { create :place, user: user }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns place to @entity' do
      expect(assigns[:entity]).to eq(place)
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

    it 'assigns new instance Place to @entity' do
      expect(assigns[:entity]).to be_a_new(Place)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, place: attributes_for(:place).merge(status: :issued) } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_users'

      it 'redirects to created place' do
        expect(response).to redirect_to(Place.last)
      end
    end

    context 'database change' do
      it 'inserts row into places table' do
        expect(action).to change(Place, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: place }

    it_behaves_like 'page_for_users'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: place }

    it_behaves_like 'page_for_users'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: place, place: { name: 'new value' }
    end

    it_behaves_like 'page_for_users'
    it_behaves_like 'entity_assigner'

    it 'updates place' do
      place.reload
      expect(place.name).to eq('new value')
    end

    it 'redirects to place page' do
      expect(response).to redirect_to(place)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: place } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'page_for_users'

      it 'redirects to places page' do
        expect(response).to redirect_to(my_places_path)
      end
    end

    it 'removes place from database' do
      expect(action).to change(Place, :count).by(-1)
    end
  end
end
