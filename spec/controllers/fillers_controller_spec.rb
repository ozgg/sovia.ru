require 'rails_helper'

RSpec.describe FillersController, type: :controller do
  let(:user) { create :administrator }
  let!(:filler) { create :filler }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns filler to @entity' do
      expect(assigns[:entity]).to eq(filler)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'administrative_page'

    it 'assigns list of fillers to @collection' do
      expect(assigns[:collection]).to include(filler)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'administrative_page'

    it 'assigns new instance Filler to @entity' do
      expect(assigns[:entity]).to be_a_new(Filler)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, filler: attributes_for(:filler).merge(category: 'dream') } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

      it 'redirects to created filler' do
        expect(response).to redirect_to(Filler.last)
      end
    end

    context 'database change' do
      it 'inserts row into fillers table' do
        expect(action).to change(Filler, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: filler }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: filler }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: filler, filler: { body: 'new text' }
    end

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'updates filler' do
      filler.reload
      expect(filler.body).to eq('new text')
    end

    it 'redirects to filler page' do
      expect(response).to redirect_to(filler)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: filler } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

      it 'redirects to fillers page' do
        expect(response).to redirect_to(fillers_path)
      end
    end

    it 'removes filler from database' do
      expect(action).to change(Filler, :count).by(-1)
    end
  end
end
