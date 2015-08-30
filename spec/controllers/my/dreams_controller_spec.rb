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

  describe 'get archive' do
    let(:year) { entity.created_at.year }
    let(:month) { entity.created_at.month }

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
      let!(:entity_in_past) { create :dream, user: user, created_at: 2.months.ago, language: language }

      before(:each) { get :archive, year: year, month: month }

      it_behaves_like 'dates_assigner'

      it 'adds entities for selected month to @collection' do
        expect(assigns[:collection]).to include(entity)
      end

      it 'does not add entities in past to @collection' do
        expect(assigns[:collection]).not_to include(entity_in_past)
      end

      it 'does not include foreign entities into @collection' do
        expect(assigns[:collection]).not_to include(foreign_entity)
      end
    end
  end
end
