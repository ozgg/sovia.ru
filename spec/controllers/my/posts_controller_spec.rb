require 'rails_helper'

RSpec.describe My::PostsController, type: :controller do
  let(:user) { create :user }
  let!(:entity) { create :post, user: user }
  let!(:foreign_entity) { create :post }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
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
    let(:tag) { create :tag }
    let!(:other_entity) { create :post, user: user }

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
      let!(:entity_in_past) { create :post, user: user, created_at: 2.months.ago }

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
