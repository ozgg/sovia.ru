require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  let(:user) { create :user }
  let!(:goal) { create :goal, user: user }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:current_user).and_return(user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns goal to @entity' do
      expect(assigns[:entity]).to eq(goal)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it 'renders view "index"' do
      expect(response).to render_template(:index)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_users'

    it 'assigns new instance Goal to @entity' do
      expect(assigns[:entity]).to be_a_new(Goal)
    end

    it 'renders view "new"' do
      expect(response).to render_template(:new)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, goal: attributes_for(:goal).merge(status: :issued) } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_users'

      it 'redirects to created goal' do
        expect(response).to redirect_to(Goal.last)
      end
    end

    context 'database change' do
      it 'inserts row into goals table' do
        expect(action).to change(Goal, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: goal }

    it_behaves_like 'page_for_users'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: goal }

    it_behaves_like 'page_for_users'
    it_behaves_like 'entity_assigner'

    it 'renders view "edit"' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: goal, goal: { name: 'new name' }
    end

    it_behaves_like 'page_for_users'
    it_behaves_like 'entity_assigner'

    it 'updates goal' do
      goal.reload
      expect(goal.name).to eq('new name')
    end

    it 'redirects to goal page' do
      expect(response).to redirect_to(goal)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: goal } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'page_for_users'

      it 'redirects to goals page' do
        expect(response).to redirect_to(my_goals_path)
      end
    end

    it 'removes goal from database' do
      expect(action).to change(Goal, :count).by(-1)
    end
  end
end
