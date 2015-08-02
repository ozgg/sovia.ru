require 'rails_helper'

RSpec.describe My::CommentsController, type: :controller do
  let(:user) { create :user }
  let!(:comment) { create :comment, user: user }
  let!(:foreign_comment) { create :comment }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it 'includes comments of user into @collection' do
      expect(assigns[:collection]).to include(comment)
    end

    it 'does not include foreign comments into @collection' do
      expect(assigns[:collection]).not_to include(foreign_comment)
    end

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end
end
