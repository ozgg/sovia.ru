require 'rails_helper'

RSpec.describe CodesController, type: :controller do
  let(:user) { create :administrator }
  let!(:code) { create :code }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns code to @entity' do
      expect(assigns[:entity]).to eq(code)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_administrator'

    it 'assigns list of codes to @collection' do
      expect(assigns[:collection]).to include(code)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'

    it 'assigns new instance Code to @entity' do
      expect(assigns[:entity]).to be_a_new(Code)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, code: attributes_for(:code).merge(category: 'recovery', user_id: user.id) } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_administrator'

      it 'redirects to created code' do
        expect(response).to redirect_to(Code.last)
      end
    end

    context 'database change' do
      it 'inserts row into codes table' do
        expect(action).to change(Code, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: code }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: code }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: code, code: { payload: 'new text' }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'updates code' do
      code.reload
      expect(code.payload).to eq('new text')
    end

    it 'redirects to code page' do
      expect(response).to redirect_to(code)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: code } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'page_for_administrator'

      it 'redirects to codes page' do
        expect(response).to redirect_to(codes_path)
      end
    end

    it 'removes code from database' do
      expect(action).to change(Code, :count).by(-1)
    end
  end
end
