require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:administrator) { create :administrator }
  let(:user) { create :user }
  let!(:entity) { create :visible_post, user: user }

  before :each do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:restrict_editing)
  end

  shared_examples 'restricted_editing' do
    it 'restricts editing' do
      expect(controller).to have_received(:restrict_editing)
    end
  end

  shared_examples 'entity_assigner' do
    it 'assigns post to @entity' do
      expect(assigns[:entity]).to eq(entity)
    end
  end

  shared_examples 'setting_post_tags' do
    it 'sets post tags' do
      expect_any_instance_of(Post).to receive(:tags_string=)
      action.call
    end

    it 'caches post tags' do
      expect_any_instance_of(Post).to receive(:cache_tags!)
      action.call
    end
  end

  shared_examples 'not_setting_post_tags' do
    it 'does not set new tags' do
      expect_any_instance_of(Post).not_to receive(:tags_string=)
      action.call
    end

    it 'does not cache tags' do
      expect_any_instance_of(Post).not_to receive(:cache_tags!)
      action.call
    end
  end

  describe 'get index' do
    let!(:hidden_post) { create :post }

    context 'when user sees hidden posts' do
      before :each do
        allow(controller).to receive(:current_user).and_return(administrator)
        get :index
      end

      it 'adds hidden post to @collection' do
        expect(assigns[:collection]).to include(hidden_post)
      end
    end

    context 'when user does not see hidden posts' do
      before(:each) { get :index }

      it 'does not add hidden post to @collection' do
        expect(assigns[:collection]).not_to include(hidden_post)
      end
    end

    context 'in any case' do
      before(:each) { get :index }

      it 'assigns visible post to @collection' do
        expect(assigns[:collection]).to include(entity)
      end

      it 'renders view "index"' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_users'

    it 'assigns new Post to @entity' do
      expect(assigns[:entity]).to be_a_new(Post)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    context 'when data is valid' do
      let(:action) { -> { post :create, post: attributes_for(:post) } }

      it_behaves_like 'setting_post_tags'

      it 'creates new Post in database' do
        expect(action).to change(Post, :count).by(1)
      end

      it 'redirects to created post page' do
        action.call
        expect(response).to redirect_to(Post.last)
      end
    end

    context 'when data is invalid' do
      let(:action) { -> { post :create, post: { lead: ' ' } } }

      it_behaves_like 'not_setting_post_tags'

      it 'leaves posts table intact' do
        expect(action).not_to change(Post, :count)
      end

      it 'renders view :new' do
        action.call
        expect(response).to render_template(:new)
      end
    end

    context 'restricting access' do
      before(:each) { post :create, post: attributes_for(:post) }

      it_behaves_like 'page_for_users'
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: entity }

    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: entity }

    it_behaves_like 'entity_assigner'
    it_behaves_like 'restricted_editing'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    context 'when data is valid' do
      let(:action) { -> { patch :update, id: entity, post: { lead: 'new lead'} } }

      it_behaves_like 'setting_post_tags'

      it 'updates post' do
        action.call
        entity.reload
        expect(entity.lead).to eq('new lead')
      end

      it 'redirects to post page' do
        action.call
        expect(response).to redirect_to(entity)
      end
    end

    context 'when data is invalid' do
      let(:action) { -> { patch :update, id: entity, post: { lead: ' '} } }

      it_behaves_like 'not_setting_post_tags'

      it 'does not update post' do
        action.call
        entity.reload
        expect(entity.lead).not_to be_blank
      end

      it 'renders view "edit"' do
        action.call
        expect(response).to render_template(:edit)
      end
    end

    context 'restricting access' do
      before(:each) { patch :update, id: entity, post: { lead: 'new lead'} }

      it_behaves_like 'restricted_editing'
    end
  end

  describe 'delete destroy' do
    context 'changing database' do
      let(:action) { -> { delete :destroy, id: entity } }

      it 'removes post from database' do
        expect(action).to change(Post, :count).by(-1)
      end
    end

    context 'redirect and restriction' do
      before(:each) { delete :destroy, id: entity }

      it_behaves_like 'restricted_editing'

      it 'redirects to posts page' do
        expect(response).to redirect_to(posts_path)
      end
    end
  end

  describe 'get tagged' do
    let(:tag) { create :tag }

    before :each do
      entity.tags_string = 'test'
    end

    it 'includes posts with tag to @collection' do
      get :tagged, tag_name: 'TEST'
      expect(assigns[:collection]).to include(entity)
    end

    it 'does not include posts without tag to @collection' do
      get :tagged, tag_name: tag.name
      expect(assigns[:collection]).not_to include(entity)
    end

    it 'assigns existing tag to @tag' do
      get :tagged, tag_name: tag.name
      expect(assigns[:tag]).to eq(tag)
    end

    it 'renders view "tagged"' do
      get :tagged, tag_name: 'test'
      expect(response).to render_template(:tagged)
    end
  end

  describe 'get archive' do
    let(:year) { entity.created_at.year }
    let(:month) { entity.created_at.month }
    let!(:hidden_entity) { create :post }

    shared_examples 'dates_assigner' do
      it 'assigns @dates' do
        expect(assigns[:dates]).to have_key(year)
      end
    end

    shared_examples 'no_collection' do
      it 'does not populate @collection' do
        expect(assigns[:collection]).to be_nil
      end
    end

    context 'when nothing is passed in parameters' do
      before(:each) { get :archive }

      it_behaves_like 'dates_assigner'
      it_behaves_like 'no_collection'
    end

    context 'when year is passed' do
      before(:each) { get :archive, year: year }

      it_behaves_like 'dates_assigner'
      it_behaves_like 'no_collection'
    end

    context 'when month is passed' do
      let!(:entity_in_past) { create :visible_post, created_at: 2.months.ago }

      before(:each) { get :archive, year: year, month: month }

      it_behaves_like 'dates_assigner'

      it 'adds entities for selected month to @collection' do
        expect(assigns[:collection]).to include(entity)
      end

      it 'does not add entities in past to @collection' do
        expect(assigns[:collection]).not_to include(entity_in_past)
      end

      it 'does not add hidden entities to @collection' do
        expect(assigns[:collection]).not_to include(hidden_entity)
      end
    end
  end
end
