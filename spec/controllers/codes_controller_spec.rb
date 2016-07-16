require 'rails_helper'

RSpec.describe CodesController, type: :controller do
  let(:user) { create :administrator }
  let!(:entity) { create :code }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'

    it 'assigns a new instance of Code to @entity' do
      expect(assigns[:entity]).to be_a_new(Code)
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
    before(:each) { get :show, id: entity }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'
  end

  describe 'get edit' do
    before(:each) { get :edit, id: entity }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: entity, code: { payload: 'new text' }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'updates code' do
      entity.reload
      expect(entity.payload).to eq('new text')
    end

    it 'redirects to code page' do
      expect(response).to redirect_to(entity)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: entity } }

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
