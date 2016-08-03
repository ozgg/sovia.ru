require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create :chief_editor }
  let!(:entity) { create :post }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(subject).to receive(:restrict_editing)
    allow(Post).to receive(:find).and_call_original
  end

  shared_examples 'setting_dependent_entities' do
    it 'sets tags' do
      expect_any_instance_of(Post).to receive(:tag_ids=)
      action.call
    end

    it 'caches tags' do
      expect_any_instance_of(Post).to receive(:cache_tags!)
      action.call
    end
  end

  describe 'get index' do
    before :each do
      allow(Post).to receive(:page_for_visitors)
      get :index
    end

    it 'gets page of posts for visitors' do
      expect(Post).to have_received(:page_for_visitors)
    end

    it_behaves_like 'successful_response'
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_editors'
  end

  describe 'post create' do
    let(:action) { -> { post :create, params: { post: parameters } } }

    context 'when parameters are valid' do
      let(:parameters) { attributes_for :post }

      it_behaves_like 'setting_dependent_entities'

      it 'creates new post' do
        expect(action).to change(Post, :count).by(1)
      end

      it 'redirects to created post' do
        action.call
        expect(response).to redirect_to(Post.last)
      end
    end

    context 'when parameters are invalid' do
      let(:parameters) { { body: ' ' } }

      it 'does not create new post' do
        expect(action).not_to change(Post, :count)
      end

      it 'responds with status 400' do
        action.call
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'restricting editing' do
      let(:parameters) { attributes_for :post }

      before(:each) { action.call }

      it_behaves_like 'page_for_editors'
    end
  end

  describe 'get show' do
    context 'when entity is visible' do
      before(:each) { get :show, params: { id: entity } }

      it_behaves_like 'entity_finder'
      it_behaves_like 'successful_response'
    end

    context 'when entity is not visible' do
      let(:action) { -> { get :show, params: { id: entity } } }

      before :each do
        allow_any_instance_of(Post).to receive(:visible_to?).and_return(false)
      end

      it 'raises not_found' do
        expect(action).to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, params: { id: entity } }

    it_behaves_like 'entity_finder'
    it_behaves_like 'restricted_editing'
  end

  describe 'patch update' do
    let(:parameters) { { body: 'changed' } }
    let(:action) { -> { patch :update, params: { id: entity, post: parameters } } }

    it_behaves_like 'setting_dependent_entities'

    context 'when parameters are valid' do
      before(:each) { action.call }

      it_behaves_like 'restricted_editing'

      it 'updates post' do
        entity.reload
        expect(entity.body).to eq('changed')
      end

      it 'redirects to post' do
        expect(response).to redirect_to(entity)
      end
    end

    context 'when parameters are invalid' do
      let(:parameters) { { body: ' ' } }

      before(:each) { action.call }

      it_behaves_like 'restricted_editing'
      it_behaves_like 'http_bad_request'

      it 'does not update post' do
        entity.reload
        expect(entity.body).not_to be_blank
      end
    end
  end

  describe 'delete destroy' do
    before(:each) { delete :destroy, params: { id: entity } }

    it_behaves_like 'restricted_editing'

    it 'marks post as deleted' do
      entity.reload
      expect(entity).to be_deleted
    end

    it 'redirects to administrative posts page' do
      expect(response).to redirect_to(admin_posts_path)
    end
  end

  describe 'get tagged' do
    let(:tag) { create :tag }

    before :each do
      allow(Tag).to receive(:match_by_name!).and_return(tag)
      allow(Post).to receive(:tagged).and_call_original
      allow(Post).to receive(:page_for_visitors)
      get :tagged, params: { tag_name: tag.name }
    end

    it 'finds tag' do
      expect(Tag).to have_received(:match_by_name!)
    end

    it 'finds tagged posts' do
      expect(Post).to have_received(:tagged)
    end

    it 'prepares page for visitors' do
      expect(Post).to have_received(:page_for_visitors)
    end
  end

  describe 'get archive' do
    before :each do
      allow(subject).to receive(:collect_months)
      allow(Post).to receive(:archive).and_call_original
      allow(Post).to receive(:page_for_visitors)
      get :archive, params: parameters
    end

    shared_examples 'collecting_months' do
      it 'collects months' do
        expect(subject).to have_received(:collect_months)
      end
    end

    shared_examples 'no_archive' do
      it 'does not call Post::archive' do
        expect(Post).not_to have_received(:archive)
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

      it 'calls Post::archive' do
        expect(Post).to have_received(:archive)
      end

      it 'prepares page for visitors' do
        expect(Post).to have_received(:page_for_visitors)
      end
    end
  end
end
