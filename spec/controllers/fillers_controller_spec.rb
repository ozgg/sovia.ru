require 'rails_helper'

RSpec.describe FillersController, type: :controller do
  let!(:entity) { create :filler }
  let(:required_roles) { [:chief_editor, :editor ] }
  let(:valid_create_params) { { filler: attributes_for(:filler) } }
  let(:valid_update_params) { { id: entity.id, filler: { body: 'Changed' } } }
  let(:invalid_create_params) { { filler: { body: ' ' } } }
  let(:invalid_update_params) { { id: entity.id, filler: { body: ' ' } } }

  before :each do
    allow(subject).to receive(:require_role)
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  describe 'get new' do
    before :each do
      get :new
    end

    it_behaves_like 'required_roles'
    it_behaves_like 'http_success'
  end

  describe 'post create' do
    context 'when parameters are valid' do
      let(:action) { -> { post :create, params: valid_create_params } }

      it_behaves_like 'entity_creator'

      context 'restrictions and response' do
        before :each do
          action.call
        end

        it_behaves_like 'required_roles'

        it 'redirects to created entity' do
          expect(response).to redirect_to(admin_filler_path(entity.class.last.id))
        end
      end
    end

    context 'when parameters are invalid' do
      before :each do
        post :create, params: invalid_create_params
      end

      it_behaves_like 'http_bad_request'
    end
  end

  describe 'get edit' do
    before :each do
      get :edit, params: { id: entity.id }
    end

    it_behaves_like 'required_roles'
    it_behaves_like 'entity_finder'
    it_behaves_like 'http_success'
  end

  describe 'patch update' do
    context 'when parameters are valid' do
      before :each do
        patch :update, params: valid_update_params
      end

      it_behaves_like 'required_roles'
      it_behaves_like 'entity_finder'

      it 'redirects to entity' do
        expect(response).to redirect_to(admin_filler_path(entity.id))
      end
    end

    context 'when parameters are invalid' do
      before :each do
        patch :update, params: invalid_update_params
      end

      it_behaves_like 'required_roles'
      it_behaves_like 'entity_finder'
      it_behaves_like 'http_bad_request'
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, params: { id: entity.id } } }

    it_behaves_like 'entity_destroyer'

    context 'restrictions, lookup and response' do
      before :each do
        action.call
      end

      it_behaves_like 'required_roles'
      it_behaves_like 'entity_finder'

      it 'redirects to list of entities' do
        expect(response).to redirect_to(admin_fillers_path)
      end
    end
  end
end
