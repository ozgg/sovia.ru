require 'rails_helper'

RSpec.describe DreamsController, type: :controller do
  let(:user) { create :user }
  let!(:entity) { create :dream, user: user }
  let(:valid_creation_parameters) { { dream: attributes_for(:dream) } }
  let(:valid_parameters) { { dream: { body: 'changed' } } }
  let(:invalid_parameters) { { dream: { body: ' ' } } }

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

    it_behaves_like 'page_for_everybody'
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
    context 'when entity is visible to user' do
      before :each do
        expect_any_instance_of(entity.class).to receive(:visible_to?).and_return(true)
        get :show, params: { id: entity }
      end

      it_behaves_like 'entity_finder'
      it_behaves_like 'http_success'
    end

    context 'when entity is not visible to user' do
      let(:action) { -> { get :show, params: { id: entity } } }

      before :each do
        expect_any_instance_of(entity.class).to receive(:visible_to?).and_return(false)
      end

      it_behaves_like 'record_not_found_exception'
    end
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
        expect(response).to redirect_to(dreams_path)
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

  describe 'get tagged' do
    let(:pattern) { create :pattern }

    before :each do
      allow(Pattern).to receive(:find_by!).and_return(pattern)
      allow(entity.class).to receive(:tagged).and_call_original
      allow(entity.class).to receive(:page_for_visitors)
      get :tagged, params: { tag_name: pattern.name }
    end

    it 'finds tag' do
      expect(Pattern).to have_received(:find_by!)
    end

    it 'finds tagged posts' do
      expect(entity.class).to have_received(:tagged)
    end

    it 'prepares page for visitors' do
      expect(entity.class).to have_received(:page_for_visitors)
    end
  end

  describe 'get archive' do
    before :each do
      allow(subject).to receive(:collect_months)
      allow(entity.class).to receive(:archive).and_call_original
      allow(entity.class).to receive(:page_for_visitors)
      get :archive, params: parameters
    end

    shared_examples 'collecting_months' do
      it 'collects months' do
        expect(subject).to have_received(:collect_months)
      end
    end

    shared_examples 'no_archive' do
      it 'does not call :archive to entity class' do
        expect(entity.class).not_to have_received(:archive)
      end
    end

    context 'when no year and month is given' do
      let(:parameters) { Hash.new }

      it_behaves_like 'collecting_months'
      it_behaves_like 'no_archive'
    end

    context 'when only year is given' do
      let(:parameters) { { year: '2016' } }

      it_behaves_like 'collecting_months'
      it_behaves_like 'no_archive'
    end

    context 'when year and month are given' do
      let(:parameters) { { year: '2016', month: '07' } }

      it_behaves_like 'collecting_months'

      it 'sends :archive to entity class' do
        expect(entity.class).to have_received(:archive)
      end

      it 'prepares page for visitors' do
        expect(entity.class).to have_received(:page_for_visitors)
      end
    end
  end
end
