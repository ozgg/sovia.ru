require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:language) { create :russian_language }
  let(:user) { create :user, language: language }
  let!(:entity) { create :question, user: user, language: language }

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
    it 'assigns post to @entity' do
      expect(assigns[:entity]).to eq(entity)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it 'assigns question to @collection' do
      expect(assigns[:collection]).to include(entity)
    end

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it 'assigns new Question to @entity' do
      expect(assigns[:entity]).to be_a_new(Question)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    context 'when data is valid' do
      let(:action) { -> { post :create, question: attributes_for(:question) } }

      it 'creates new Question in database' do
        expect(action).to change(Question, :count).by(1)
      end

      it 'redirects to created question page' do
        action.call
        expect(response).to redirect_to(Question.last)
      end
    end

    context 'when data is invalid' do
      let(:action) { -> { post :create, question: { body: ' ' } } }

      it 'leaves questions table intact' do
        expect(action).not_to change(Question, :count)
      end

      it 'renders view :new' do
        action.call
        expect(response).to render_template(:new)
      end
    end

    context 'restricting access' do
      before(:each) { post :create, question: attributes_for(:question) }

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
      let(:action) { -> { patch :update, id: entity, question: { body: 'new body of question'} } }

      it 'updates question' do
        action.call
        entity.reload
        expect(entity.body).to eq('new body of question')
      end

      it 'redirects to question page' do
        action.call
        expect(response).to redirect_to(entity)
      end
    end

    context 'when data is invalid' do
      let(:action) { -> { patch :update, id: entity, question: { body: ' '} } }

      it 'does not update question' do
        action.call
        entity.reload
        expect(entity.body).not_to be_blank
      end

      it 'renders view "edit"' do
        action.call
        expect(response).to render_template(:edit)
      end
    end

    context 'restricting access' do
      before(:each) { patch :update, id: entity, question: { body: 'new body of question'} }

      it_behaves_like 'restricted_editing'
    end
  end

  describe 'delete destroy' do
    context 'changing database' do
      let(:action) { -> { delete :destroy, id: entity } }

      it 'removes question from database' do
        expect(action).to change(Question, :count).by(-1)
      end
    end

    context 'redirect and restriction' do
      before(:each) { delete :destroy, id: entity }

      it_behaves_like 'restricted_editing'

      it 'redirects to questions page' do
        expect(response).to redirect_to(questions_path)
      end
    end
  end
end
