require 'rails_helper'

RSpec.describe GrainsController, type: :controller do
  let(:user) { create :user }
  let(:entity) { create :grain, user: user }
  let(:foreign_entity) { create :grain }
  let(:valid_creation_parameters) { { grain: attributes_for(:grain) } }
  let(:valid_parameters) { { grain: { name: 'Changed' } } }
  let(:invalid_parameters) { { grain: { name: ' ' } } }

  before :each do
    allow(subject).to receive(:current_user).and_return(user)
    allow(subject).to receive(:restrict_anonymous_access)
    allow(entity.class).to receive(:find).and_call_original
  end

  describe 'get new' do
    before :each do
      get :new
    end

    it_behaves_like 'page_for_user'
    it_behaves_like 'http_success'
  end

  describe 'post create' do
    context 'when parameters are valid' do
      let(:action) { -> { post :create, params: valid_creation_parameters } }

      it_behaves_like 'entity_creator'

      context 'redirect and constraints' do
        before :each do
          action.call
        end

        it_behaves_like 'page_for_user'
        it_behaves_like 'new_entity_owned_by_user'

        it 'redirects to entity page' do
          expect(response).to redirect_to(my_grain_path(entity.class.last))
        end
      end
    end

    context 'when parameters are invalid' do
      let(:action) { -> { post :create, params: invalid_parameters } }

      it_behaves_like 'entity_constant_count'

      context 'authentication and response' do
        before :each do
          action.call
        end

        it_behaves_like 'page_for_user'
        it_behaves_like 'http_bad_request'
      end
    end
  end

  describe 'get edit' do
    context 'when entity is owned by user' do
      before :each do
        get :edit, params: { id: entity }
      end

      it_behaves_like 'page_for_user'
      it_behaves_like 'entity_finder'
      it_behaves_like 'successful_response'
    end

    context 'when entity is not owned by user' do
      let(:action) { -> { get :edit, params: { id: foreign_entity } } }

      it_behaves_like 'record_not_found_exception'
    end
  end

  describe 'patch update' do
    context 'when entity is owned by user' do
      context 'when parameters are valid' do
        before :each do
          patch :update, params: { id: entity }.merge(valid_parameters)
        end

        it_behaves_like 'page_for_user'

        it 'updates entity' do
          entity.reload
          expect(entity.name).to eq('Changed')
        end

        it 'redirects to entity page' do
          expect(response).to redirect_to(my_grain_path(entity))
        end
      end

      context 'when parameters are invalid' do
        before :each do
          patch :update, params: { id: entity }.merge(invalid_parameters)
        end

        it_behaves_like 'page_for_user'
        it_behaves_like 'http_bad_request'

        it 'does not change entity' do
          entity.reload
          expect(entity.name).not_to be_blank
        end
      end
    end

    context 'when entity is not owned by user' do
      let(:action) { -> { patch :update, params: { id: foreign_entity }.merge(valid_parameters) } }

      it_behaves_like 'record_not_found_exception'
    end
  end

  describe 'delete destroy' do
    context 'when entity is owned by user' do
      let(:action) { -> { delete :destroy, params: { id: entity } } }

      it_behaves_like 'entity_destroyer'

      it 'redirects to entity list' do
        action.call
        expect(response).to redirect_to(my_grains_path)
      end
    end

    context 'when entity is not owned by user' do
      let(:action) { -> { delete :destroy, params: { id: foreign_entity } } }

      it_behaves_like 'record_not_found_exception'
    end
  end
end
