require 'rails_helper'

RSpec.describe My::SideNotesController, type: :controller, wip: true do
  let(:language) { create :russian_language }
  let(:user) { create :user, language: language }
  let!(:entity) { create :side_note, user: user, language: language }
  let!(:foreign_entity) { create :side_note, language: language }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
    I18n.locale = language.code
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
