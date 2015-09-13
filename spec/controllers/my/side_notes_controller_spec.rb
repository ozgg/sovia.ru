require 'rails_helper'

RSpec.describe My::SideNotesController, type: :controller do
  let(:user) { create :user }
  let!(:entity) { create :side_note, user: user }
  let!(:foreign_entity) { create :side_note }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_users'

    it 'includes side notes of user into @collection' do
      expect(assigns[:collection]).to include(entity)
    end

    it 'does not include foreign side notes into @collection' do
      expect(assigns[:collection]).not_to include(foreign_entity)
    end

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end
end
