require 'rails_helper'

RSpec.describe DreamsController, type: :controller do
  let!(:entity) { create :dream }
  let(:valid_create_params) { { dream: attributes_for(:dream) } }
  let(:valid_update_params) { { id: entity.id, dream: { body: 'Changed' } } }
  let(:invalid_create_params) { { dream: { body: ' ' } } }
  let(:invalid_update_params) { { id: entity.id, dream: { body: ' ' } } }
  let(:path_after_create) { dream_path(entity.class.last.id) }
  let(:path_after_update) { dream_path(entity.id) }
  let(:path_after_destroy) { dreams_path }

  before :each do
    allow(subject).to receive(:require_role)
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  it_behaves_like 'index_entities_without_required_roles'
  it_behaves_like 'new_entity_without_required_roles'
  it_behaves_like 'create_entity_without_required_roles'
  it_behaves_like 'show_entity_with_visibility_check'
  it_behaves_like 'edit_entity_with_editability_check'
  it_behaves_like 'update_entity_with_editability_check'
  it_behaves_like 'delete_entity_with_editability_check'

  describe 'get tagged' do
    let(:pattern) { create :pattern }

    before :each do
      allow(Pattern).to receive(:find_by).and_return(pattern)
      allow(entity.class).to receive(:tagged).and_call_original
      allow(entity.class).to receive(:page_for_visitors)
      get :tagged, params: { tag_name: pattern.name }
    end

    it_behaves_like 'no_roles_required'
    it_behaves_like 'http_success'

    it 'finds tag' do
      expect(Pattern).to have_received(:find_by)
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
      it_behaves_like 'no_roles_required'
      it_behaves_like 'http_success'
    end

    context 'when only year is given' do
      let(:parameters) { { year: '2016' } }

      it_behaves_like 'collecting_months'
      it_behaves_like 'no_archive'
      it_behaves_like 'no_roles_required'
      it_behaves_like 'http_success'
    end

    context 'when year and month are given' do
      let(:parameters) { { year: '2016', month: '07' } }

      it_behaves_like 'collecting_months'
      it_behaves_like 'no_roles_required'
      it_behaves_like 'http_success'

      it 'sends :archive to entity class' do
        expect(entity.class).to have_received(:archive)
      end

      it 'prepares page for visitors' do
        expect(entity.class).to have_received(:page_for_visitors)
      end
    end
  end

  describe 'get random' do
    before :each do
      create :dream
      get :random
    end

    it_behaves_like 'no_roles_required'
    it_behaves_like 'http_success'
  end
end
