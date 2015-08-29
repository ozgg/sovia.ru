require 'rails_helper'

RSpec.describe SideNotesController, type: :controller do
  let!(:language) { create :russian_language }
  let(:administrator) { create :administrator, language: language }
  let(:user) { create :user, language: language }
  let!(:entity) { create :active_side_note, user: user, language: language }

  before :each do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:restrict_editing)
    I18n.locale = language.code
  end

  shared_examples 'restricted_editing' do
    it 'restricts editing' do
      expect(controller).to have_received(:restrict_editing)
    end
  end

  shared_examples 'entity_assigner' do
    it 'assigns side note to @entity' do
      expect(assigns[:entity]).to eq(entity)
    end
  end

  describe 'get index' do
    let!(:hidden_note) { create :side_note, language: language }

    context 'when user sees inactive notes' do
      before :each do
        allow(controller).to receive(:current_user).and_return(administrator)
        get :index
      end

      it 'adds inactive note to @collection' do
        expect(assigns[:collection]).to include(hidden_note)
      end
    end

    context 'when user does not see inactive notes' do
      before(:each) { get :index }

      it 'does not add inactive note to @collection' do
        expect(assigns[:collection]).not_to include(hidden_note)
      end
    end

    context 'in any case' do
      before(:each) { get :index }

      it 'assigns active note to @collection' do
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

    it 'assigns new SideNote to @entity' do
      expect(assigns[:entity]).to be_a_new(SideNote)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    context 'when data is valid' do
      let(:action) { -> { post :create, side_note: attributes_for(:side_note) } }

      it 'creates new SideNote in database' do
        expect(action).to change(SideNote, :count).by(1)
      end

      it 'redirects to created side note page' do
        action.call
        expect(response).to redirect_to(SideNote.last)
      end
    end

    context 'when data is invalid' do
      let(:action) { -> { post :create, side_note: { title: ' ' } } }

      it 'leaves side notes table intact' do
        expect(action).not_to change(SideNote, :count)
      end

      it 'renders view :new' do
        action.call
        expect(response).to render_template(:new)
      end
    end

    context 'restricting access' do
      before(:each) { post :create, side_note: attributes_for(:side_note) }

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
      let(:action) { -> { patch :update, id: entity, side_note: { title: 'new text'} } }

      it 'updates entity' do
        action.call
        entity.reload
        expect(entity.title).to eq('new text')
      end

      it 'redirects to entity page' do
        action.call
        expect(response).to redirect_to(entity)
      end
    end

    context 'when data is invalid' do
      let(:action) { -> { patch :update, id: entity, side_note: { title: ' '} } }

      it 'does not update entity' do
        action.call
        entity.reload
        expect(entity.title).not_to be_blank
      end

      it 'renders view "edit"' do
        action.call
        expect(response).to render_template(:edit)
      end
    end

    context 'restricting access' do
      before(:each) { patch :update, id: entity, side_note: { title: 'new text'} }

      it_behaves_like 'restricted_editing'
    end
  end

  describe 'delete destroy' do
    context 'changing database' do
      let(:action) { -> { delete :destroy, id: entity } }

      it 'removes entity from database' do
        expect(action).to change(SideNote, :count).by(-1)
      end
    end

    context 'redirect and restriction' do
      before(:each) { delete :destroy, id: entity }

      it_behaves_like 'restricted_editing'

      it 'redirects to side notes page' do
        expect(response).to redirect_to(side_notes_path)
      end
    end
  end
end
