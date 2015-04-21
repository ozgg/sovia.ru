require 'rails_helper'

RSpec.describe PatternsController, type: :controller do
  let(:editor) { create :dreambook_editor }
  let(:manager) { create :dreambook_manager }
  let!(:pattern) { create :pattern }

  before :each do
    allow(controller).to receive(:restrict_editing_access)
    allow(controller).to receive(:restrict_management_access)
  end

  shared_examples 'setter' do
    it 'assigns pattern to @pattern' do
      expect(assigns[:pattern]).to eq(pattern)
    end
  end

  shared_examples 'editing restriction' do
    it 'calls #restrict_editing_access' do
      expect(controller).to have_received(:restrict_editing_access)
    end
  end

  shared_examples 'management restriction' do
    it 'calls #restrict_editing_access' do
      expect(controller).to have_received(:restrict_management_access)
    end
  end

  shared_examples 'no restrictions' do
    it 'does not demand editor role' do
      expect(controller).not_to have_received(:restrict_editing_access)
    end

    it 'does not demand manager role' do
      expect(controller).not_to have_received(:restrict_management_access)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it 'assigns @patterns with pattern inside' do
      expect(assigns[:patterns]).to include(pattern)
    end

    it_should_behave_like 'no restrictions'
  end

  describe 'get new' do
    before :each do
      session[:user_id] = editor.id
      get :new
    end

    it 'assigns a new pattern to @pattern' do
      expect(assigns[:pattern]).to be_a_new(Pattern)
    end

    it_should_behave_like 'editing restriction'
  end

  describe 'post create' do
    let(:action) { -> { post :create, pattern: { name: 'Yay!' } } }
    before(:each) { session[:user_id] = editor.id }

    context 'checking and redirection' do
      before(:each) { action.call }

      it 'resirects to created pattern' do
        expect(response).to redirect_to(Pattern.last)
      end

      it_should_behave_like 'editing restriction'
    end

    context 'changing database' do
      it 'inserts Pattern into database' do
        expect(action).to change(Pattern, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: pattern.id }

    it_should_behave_like 'no restrictions'
    it_should_behave_like 'setter'
  end

  describe 'get edit' do
    before :each do
      session[:user_id] = editor.id
      get :edit, id: pattern.id
    end

    it_should_behave_like 'editing restriction'
    it_should_behave_like 'setter'
  end

  describe 'patch update' do
    before :each do
      session[:user_id] = editor.id
      patch :update, id: pattern.id, pattern: { body: 'new description' }
    end

    it 'updates Pattern' do
      pattern.reload
      expect(pattern.body).to eq('new description')
    end

    it 'redirects to pattern page' do
      expect(response).to redirect_to(pattern)
    end

    it_should_behave_like 'editing restriction'
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: pattern.id } }
    before(:each) { session[:user_id] = manager.id }

    context 'checking and redirecting' do
      before(:each) { action.call }

      it 'redirects to patterns path' do
        expect(response).to redirect_to(patterns_path)
      end

      it_should_behave_like 'management restriction'
    end

    context 'changing database' do
      it 'removes pattern from database' do
        expect(action).to change(Pattern, :count).by(-1)
      end
    end
  end
end
