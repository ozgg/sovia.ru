require 'rails_helper'

RSpec.describe FillersController, type: :controller do
  let(:user) { create :administrator }
  let!(:filler) { create :filler }

  before :each do
    session[:user_id] = user.id
    allow(controller).to receive(:allow_administrators_only)
  end

  shared_examples 'setter' do
    it 'assigns filler to @filler' do
      expect(assigns[:filler]).to eq(filler)
    end
  end

  shared_examples 'checker' do
    it 'allows administrators only' do
      expect(controller).to have_received(:allow_administrators_only)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it 'assigns @fillers with filler' do
      expect(assigns[:fillers]).to include(filler)
    end

    it_should_behave_like 'checker'
  end

  describe 'get new' do
    before(:each) { get :new }

    it 'assigns new Filler to @filler' do
      expect(assigns[:filler]).to be_a_new(Filler)
    end

    it_should_behave_like 'checker'
  end

  describe 'post create' do
    let(:action) { -> { post :create, filler: { queue: :question, body: 'aaa' } } }

    context 'checking and redirecting' do
      before(:each) { action.call }

      it 'redirects to new filler' do
        expect(response).to redirect_to(Filler.last)
      end

      it_should_behave_like 'checker'
    end

    context 'creating record in database' do
      it 'creates new Filler in database' do
        expect(action).to change(Filler, :count).by(1)
      end
    end
  end

  describe 'get edit' do
    before(:each) { get :edit, id: filler.id }

    it_should_behave_like 'setter'
    it_should_behave_like 'checker'
  end

  describe 'patch update' do
    let(:action) { -> { patch :update, id: filler.id, filler: { body: 'aaa' } } }

    context 'setting and checking' do
      before(:each) { action.call }

      it_should_behave_like 'setter'
      it_should_behave_like 'checker'
    end

    context 'updating model' do
      it 'updates filler' do
        action.call
        filler.reload
        expect(filler.body).to eq('aaa')
      end
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: filler.id } }

    context 'checking and redirecting' do
      before(:each) { action.call }

      it 'redirects to fillers list' do
        expect(response).to redirect_to(fillers_path)
      end

      it_should_behave_like 'checker'
    end

    context 'changing database' do
      it 'removes filler from database' do
        expect(action).to change(Filler, :count).by(-1)
      end
    end
  end
end
