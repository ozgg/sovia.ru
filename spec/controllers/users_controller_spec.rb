require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:current_user) { create :administrator }
  let!(:user) { create :user }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(User).to receive(:with_long_slug).and_return(user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns user to @entity' do
      expect(assigns[:entity]).to eq(user)
    end
  end

  shared_examples 'user_assigner' do
    it 'finds user by long slug' do
      expect(User).to have_received(:with_long_slug).with(user.long_slug)
    end

    it 'assigns user to @user' do
      expect(assigns[:user]).to eq(user)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_administrator'

    it 'assigns list of users to @collection' do
      expect(assigns[:collection]).to include(user)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'

    it 'assigns new instance User to @entity' do
      expect(assigns[:entity]).to be_a_new(User)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, user: attributes_for(:user).merge(network: 'native') } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_administrator'

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

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: user }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: user, user: { name: 'new name' }
    end

    it_behaves_like 'page_for_administrator'
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
    before(:each) { delete :destroy, id: user }

    context 'authorization' do
      it_behaves_like 'page_for_administrator'

      it 'redirects to users page' do
        expect(response).to redirect_to(users_path)
      end
    end

    it 'marks user as deleted' do
      user.reload
      expect(user).to be_deleted
    end
  end

  describe 'get profile' do
    before(:each) { get :profile, slug: user.long_slug }

    it_behaves_like 'user_assigner'

    it 'renders view "profile"' do
      expect(response).to render_template(:profile)
    end
  end
end
