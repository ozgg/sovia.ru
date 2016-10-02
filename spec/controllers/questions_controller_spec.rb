require 'rails_helper'

RSpec.describe QuestionsController, type: :controller, focus: true do
  let(:user) { create :user }
  let!(:entity) { create :question, user: user }
  let(:valid_creation_parameters) { { question: attributes_for(:question) } }
  let(:valid_parameters) { { question: { body: 'changed' } } }
  let(:invalid_parameters) { { question: { body: ' ' } } }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(entity.class).to receive(:find).and_call_original
  end

  it_behaves_like 'list_for_visitors'

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

      it 'redirects to created entity' do
        action.call
        expect(response).to redirect_to(entity.class.last)
      end
    end

    context 'when parameters are invalid' do
      before :each do
        post :create, params: invalid_parameters
      end

      it_behaves_like 'http_bad_request'
    end
  end

  describe 'get show' do
    before :each do
      get :show, params: { id: entity }
    end

    it_behaves_like 'entity_finder'
    it_behaves_like 'http_success'
  end

  describe 'get edit' do
    context 'when entity is editable by user' do
      before :each do
        expect_any_instance_of(entity.class).to receive(:editable_by?).and_return(true)
        get :edit, params: { id: entity }
      end

      it_behaves_like 'http_success'
    end

    context 'when entity is not editable by user' do
      let(:action) { -> { get :edit, params: { id: entity } } }

      before :each do
        expect_any_instance_of(entity.class).to receive(:editable_by?).and_return(false)
      end

      it_behaves_like 'record_not_found_exception'
    end
  end

  describe 'patch update' do
    context 'when entity is editable by user' do
      before :each do
        expect_any_instance_of(entity.class).to receive(:editable_by?).and_return(true)

        patch :update, params: { id: entity }.merge(valid_parameters)
      end

      it 'updates entity' do
        entity.reload
        expect(entity.body).to eq('changed')
      end

      it 'redirects to entity' do
        expect(response).to redirect_to(entity)
      end
    end

    context 'when parameters are invalid' do
      before :each do
        expect_any_instance_of(entity.class).to receive(:editable_by?).and_return(true)

        patch :update, params: { id: entity }.merge(invalid_parameters)
      end

      it_behaves_like 'http_bad_request'
    end

    context 'when entity is not editable by user' do
      let(:action) { -> { patch :update, params: { id: entity }.merge(valid_parameters) } }

      before :each do
        expect_any_instance_of(entity.class).to receive(:editable_by?).and_return(false)
      end

      it_behaves_like 'record_not_found_exception'
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, params: { id: entity } } }

    context 'when entity is editable by user' do
      before :each do
        expect_any_instance_of(entity.class).to receive(:editable_by?).and_return(true)
        action.call
      end

      it_behaves_like 'entity_deleter'

      it 'redirects to list of entities' do
        expect(response).to redirect_to(questions_path)
      end
    end

    context 'when entity is not editable by user' do
      let(:action) { -> { get :edit, params: { id: entity } } }

      before :each do
        expect_any_instance_of(entity.class).to receive(:editable_by?).and_return(false)
      end

      it_behaves_like 'record_not_found_exception'
    end
  end
end
