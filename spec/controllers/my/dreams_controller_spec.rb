require 'rails_helper'

RSpec.describe My::DreamsController, type: :controller do
  let(:language) { create :russian_language }
  let(:user) { create :user, language: language }
  let!(:entity) { create :personal_dream, user: user, language: language }
  let!(:foreign_entity) { create :dream_for_community, language: language }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
    I18n.locale = language.code
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_users'

    it 'includes dreams of user into @collection' do
      expect(assigns[:collection]).to include(entity)
    end

    it 'does not include foreign dreams into @collection' do
      expect(assigns[:collection]).not_to include(foreign_entity)
    end

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end

  describe 'get tagged' do
    let(:grain) { create :grain, language: language, user: user }
    let!(:other_entity) { create :dream_for_community, user: user, language: language }

    before :each do
      entity.grains_string = 'test(pattern)'
      foreign_entity.grains_string = 'test(pattern)'
      other_entity.grains_string = grain.name
      get :tagged, tag_name: 'TEST'
    end

    it_behaves_like 'page_for_users'

    it 'includes dream of user with grain into @collection' do
      expect(assigns[:collection]).to include(entity)
    end

    it 'does not include foreign dream with user into @collection' do
      expect(assigns[:collection]).not_to include(foreign_entity)
    end

    it 'does not include dreams with other grains' do
      expect(assigns[:collection]).not_to include(other_entity)
    end

    it 'assigns selected grain to @grain' do
      expect(assigns[:grain]).to eq(entity.grains.first)
    end
  end
end
