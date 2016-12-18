require 'rails_helper'

RSpec.describe PlacesController, type: :controller do
  let(:user) { create :user }
  let(:entity) { create :place, user: user }
  let(:foreign_entity) { create :place }
  let(:valid_creation_parameters) { { place: attributes_for(:place) } }
  let(:valid_parameters) { { place: { name: 'Changed' } } }
  let(:invalid_parameters) { { place: { name: ' ' } } }

  before :each do
    allow(subject).to receive(:current_user).and_return(user)
    allow(subject).to receive(:restrict_anonymous_access)
    expect(entity.class).to receive(:owned_by).and_call_original
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  shared_examples 'reached_place_limit' do
    it 'redirects to places list' do
      expect(response).to redirect_to(my_places_path)
    end
  end

  describe 'get new' do
    let(:action) { -> { get :new } }

    context 'when place limit is not reached' do
      before :each do
        action.call
      end

      it_behaves_like 'page_for_user'
      it_behaves_like 'http_success'
    end

    context 'when place limit is reached' do
      before :each do
        allow_any_instance_of(Place::ActiveRecord_Relation).to receive(:count).and_return(User::PLACE_LIMIT)
        action.call
      end

      it_behaves_like 'reached_place_limit'
    end
  end

  describe 'post create' do
    context 'when place limit is not reached' do
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
            expect(response).to redirect_to(my_place_path(entity.class.last))
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

    context 'when place limit is reached' do
      before :each do
        allow_any_instance_of(Place::ActiveRecord_Relation).to receive(:count).and_return(User::PLACE_LIMIT)
        post :create, params: valid_parameters
      end

      it_behaves_like 'reached_place_limit'
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
          expect(response).to redirect_to(my_place_path(entity))
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
  end

  describe 'delete destroy' do
    context 'when entity is owned by user' do
      let(:action) { -> { delete :destroy, params: { id: entity } } }

      it_behaves_like 'entity_destroyer'

      it 'redirects to entity list' do
        action.call
        expect(response).to redirect_to(my_places_path)
      end
    end
  end
end
