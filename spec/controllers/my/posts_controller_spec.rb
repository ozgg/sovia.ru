require 'rails_helper'

RSpec.describe My::PostsController, type: :controller do
  let(:language) { create :russian_language }
  let(:user) { create :user, language: language }
  let!(:entity) { create :post, user: user, language: language }
  let!(:foreign_entity) { create :post, language: language }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
    I18n.locale = language.code
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_users'

    it 'includes posts of user into @collection' do
      expect(assigns[:collection]).to include(entity)
    end

    it 'does not include foreign posts into @collection' do
      expect(assigns[:collection]).not_to include(foreign_entity)
    end

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end

  describe 'get tagged' do
    let(:tag) { create :tag, language: language }
    let!(:other_entity) { create :post, user: user, language: language }

    before :each do
      entity.tags_string = 'test'
      foreign_entity.tags_string = 'test'
      other_entity.tags = [tag]
      get :tagged, tag_name: 'TEST'
    end

    it_behaves_like 'page_for_users'

    it 'includes post of user with tag into @collection' do
      expect(assigns[:collection]).to include(entity)
    end

    it 'does not include foreign post with user into @collection' do
      expect(assigns[:collection]).not_to include(foreign_entity)
    end

    it 'does not include posts with other tags' do
      expect(assigns[:collection]).not_to include(other_entity)
    end

    it 'assigns selected tag to @tag' do
      expect(assigns[:tag]).to eq(entity.tags.first)
    end
  end
end
