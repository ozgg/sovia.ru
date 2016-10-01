require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let!(:entity) { create :user }

  before :each do
    allow(entity.class).to receive(:with_long_slug).and_return(entity)
  end

  shared_examples 'finding_user_by_slug' do
    it 'finds user by long slug' do
      expect(User).to have_received(:with_long_slug).with(entity.long_slug)
    end
  end

  describe 'get show' do
    let(:action) { -> { get :show, params: { slug: entity.long_slug } } }

    it_behaves_like 'not_found_deleted_entity'

    context 'when user is not deleted' do
      before :each do
        action.call
      end

      it_behaves_like 'http_success'
      it_behaves_like 'finding_user_by_slug'
    end
  end

  describe 'get dreams' do
    before :each do
      allow(Dream).to receive(:page_for_visitors)
      get :dreams, params: { slug: entity.long_slug }
    end

    it_behaves_like 'finding_user_by_slug'

    it 'prepares list of dreams' do
      expect(Dream).to have_received(:page_for_visitors)
    end
  end

  describe 'get posts' do
    before :each do
      allow(Post).to receive(:page_for_visitors)
      get :posts, params: { slug: entity.long_slug }
    end

    it_behaves_like 'finding_user_by_slug'

    it 'prepares list of posts' do
      expect(Post).to have_received(:page_for_visitors)
    end
  end
end
