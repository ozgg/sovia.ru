require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:current_user) { create :administrator }
  let!(:entity) { create :user }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(current_user)
    allow(User).to receive(:with_long_slug).and_return(entity)
  end

  shared_examples 'user_assigner' do
    it 'finds user by long slug' do
      expect(User).to have_received(:with_long_slug).with(entity.long_slug)
    end

    it 'assigns user to @user' do
      expect(assigns[:user]).to eq(entity)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'

    it 'assigns a new instance of User to @entity' do
      expect(assigns[:entity]).to be_a_new(User)
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
    before(:each) { get :show, id: entity }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: entity }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: entity, user: { name: 'changed' }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_assigner'

    it 'updates user' do
      entity.reload
      expect(entity.name).to eq('changed')
    end

    it 'redirects to user page' do
      expect(response).to redirect_to(entity)
    end
  end

  describe 'delete destroy' do
    before(:each) { delete :destroy, id: entity }

    context 'authorization' do
      it_behaves_like 'page_for_administrator'

      it 'redirects to users page' do
        expect(response).to redirect_to(users_path)
      end
    end

    it 'marks user as deleted' do
      entity.reload
      expect(entity).to be_deleted
    end
  end
end
