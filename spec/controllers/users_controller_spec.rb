require 'rails_helper'

RSpec.describe UsersController, type: :controller, wip: true do
  let(:current_user) { create :administrator }
  let!(:language) { create :russian_language }
  let!(:user) { create :user }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns user to @entity' do
      expect(assigns[:entity]).to eq(user)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'administrative_page'

    it 'assigns list of users to @collection' do
      expect(assigns[:collection]).to include(user)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'administrative_page'

    it 'assigns new instance User to @entity' do
      expect(assigns[:entity]).to be_a_new(User)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, user: attributes_for(:user).merge(network: 'native', language_id: language.id) } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

      it 'redirects to created user' do
        expect(response).to redirect_to(User.last)
      end
    end

    context 'database change' do
      it 'inserts row into users table' do
        expect(action).to change(User, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: user }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: user }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: user, user: { name: 'new name' }
    end

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'updates user' do
      user.reload
      expect(user.name).to eq('new name')
    end

    it 'redirects to user page' do
      expect(response).to redirect_to(user)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: user } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

      it 'redirects to users page' do
        expect(response).to redirect_to(users_path)
      end
    end

    it 'removes user from database' do
      expect(action).to change(User, :count).by(-1)
    end
  end

  describe 'get profile' do
    pending
  end

  describe 'get dreams' do
    pending
  end

  describe 'get posts' do
    pending
  end

  describe 'get questions' do
    pending
  end

  describe 'get comments' do
    pending
  end
end
