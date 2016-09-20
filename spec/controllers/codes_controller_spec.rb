require 'rails_helper'

RSpec.describe CodesController, type: :controller do
  let(:user) { create :administrator }
  let!(:entity) { create :code }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(entity.class).to receive(:find).and_call_original
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'http_success'
  end

  describe 'post create' do
    let(:action) { -> { post :create, params: params } }

    context 'when parameters are valid' do
      let(:params) { { code: attributes_for(:code).merge(category: 'recovery', user_id: user.id) } }

      it_behaves_like 'entity_creator'

      context 'authorization and redirects' do
        before :each do
          action.call
        end

        it_behaves_like 'page_for_administrator'

        it 'redirects to created entity' do
          expect(response).to redirect_to(admin_code_path(entity.class.last))
        end
      end
    end

    context 'when parameters are invalid' do
      let(:params) { { code: { body: ' ' } } }

      it_behaves_like 'entity_constant_count'

      context 'response status' do
        before :each do
          action.call
        end

        it_behaves_like 'http_bad_request'
      end
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, params: { id: entity } }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'
    it_behaves_like 'http_success'
  end

  describe 'patch update' do
    context 'when parameters are valid' do
      before :each do
        patch :update, params: { id: entity, code: { payload: 'changed' } }
      end

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'entity_finder'

      it 'updates code' do
        entity.reload
        expect(entity.payload).to eq('changed')
      end

      it 'redirects to entity page' do
        expect(response).to redirect_to(admin_code_path(entity))
      end
    end

    context 'when parameters are invalid' do
      before :each do
        patch :update, params: { id: entity, code: { body: ' ' } }
      end

      it_behaves_like 'http_bad_request'

      it 'does not change entity' do
        entity.reload
        expect(entity.body).not_to be_blank
      end
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, params: { id: entity } } }

    it_behaves_like 'entity_destroyer'

    context 'authorization' do
      before :each do
        action.call
      end

      it_behaves_like 'page_for_administrator'

      it 'redirects to entities page' do
        expect(response).to redirect_to(admin_codes_path)
      end
    end
  end
end
