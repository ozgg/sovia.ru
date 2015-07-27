require 'rails_helper'

RSpec.describe PostsController, type: :controller, wip: true do
  let(:language) { create :russian_language }
  let(:administrator) { create :administrator, language: language }
  let(:owner) { create :user, language: language }
  let(:user) { create :user, language: language }
  let!(:entity) { create :visible_post, language: language }

  before :each do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:restrict_anonymous_access)
  end

  shared_examples 'restricted_editing' do
    it 'restricts editing'
  end

  shared_examples 'entity_assigner' do
    it 'assigns post to @entity' do
      expect(assigns[:entity]).to eq(entity)
    end
  end

  describe 'get index' do
    let!(:hidden_post) { create :post, language: language }

    context 'when user sees hidden posts' do
      it 'adds hidden post to @collection'
    end

    context 'when user does not see hidden posts' do
      it 'does not add hidden post to @collection'
    end

    context 'in any case' do
      it 'assigns visible post to @collection'
      it 'renders view "index"'
    end
  end

  describe 'get new' do
    it_behaves_like 'page_for_users'

    it 'assigns new Post to @entity'
    it 'renders view "new"'
  end

  describe 'post create' do
    context 'when data is valid' do
      it 'creates new Post in database'
      it 'redirects to created post page'
    end

    context 'when data is invalid' do
      it 'leaves posts table intact'
      it 'renders view :new'
    end

    context 'restricting access' do
      it_behaves_like 'page_for_users'
    end
  end

  describe 'get show' do
    it_behaves_like 'entity_assigner'

    it 'renders view "show"'
  end

  describe 'get edit' do
    it_behaves_lile 'entity_assigner'
    it_behaves_like 'restricted_editing'
    it 'renders view "edit"'
  end

  describe 'patch update' do
    context 'when data is valid' do
      it 'updates post'
      it 'redirects to post page'
    end

    context 'when data is invalid' do
      it 'does not update post'
      it 'renders view "edit"'
    end

    context 'restricting access' do
      it_behaves_like 'restricted_editing'
    end
  end

  describe 'delete destroy' do
    context 'changing database' do
      it 'removes post from database'
    end

    context 'redirect and restriction' do
      it_behaves_like 'restricted_editing'

      it 'redirects to posts page'
    end
  end

  describe 'get tagged' do
    it 'includes posts with tag to @collection'
    it 'does not include posts without tag to @collection'
    it 'renders view "tagged"'
  end
end
