require 'rails_helper'

RSpec.describe My::QuestionsController, type: :controller do
  let(:user) { create :user }
  let!(:question) { create :question, user: user }
  let!(:foreign_question) { create :question }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_users'

    it 'includes questions of user into @collection' do
      expect(assigns[:collection]).to include(question)
    end

    it 'does not include foreign questions into @collection' do
      expect(assigns[:collection]).not_to include(foreign_question)
    end

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end
end
