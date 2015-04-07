require 'rails_helper'

RSpec.describe DeedsController, type: :controller do
  let(:user) { create :unconfirmed_user }
  let(:another_user) { create :unconfirmed_user }
  let!(:deed) { create :deed, user: user }

  before :each do
    session[:user_id] = user.id
    allow(controller).to receive(:allow_authorized_only)
    allow(controller).to receive(:track_agent)
  end

  shared_examples 'successful response' do
    it 'returns HTTP success' do
      expect(response).to have_http_status(:success)
    end
  end

  shared_examples 'tracking' do
    it 'tracks user agent' do
      expect(controller).to have_received(:track_agent)
    end
  end

  shared_examples 'validating authorization' do
    it 'calls :allow_authorized_only' do
      expect(controller).to have_received(:allow_authorized_only)
    end
  end

  shared_examples 'deed setter' do
    it 'assigns deed to @deed' do
      expect(assigns[:deed]).to be_instance_of(Deed)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_should_behave_like 'successful response'
  end

  describe 'get new' do
    before(:each) { get :new }

    it_should_behave_like 'successful response'
    it_should_behave_like 'deed setter'
    it_should_behave_like 'validating authorization'
  end

  describe 'post create' do
    let(:action) { -> { post :create, deed: { name: 'My deed' } } }
    context 'validation and redirects' do
      before(:each) { action.call }

      it 'redirects to user deeds' do
        expect(response).to redirect_to(my_deeds_path)
      end

      it_should_behave_like 'validating authorization'
    end

    context 'changing database' do
      it 'adds deed to database' do
        expect(action).to change(Deed, :count).by(1)
      end
    end
  end

  describe 'get edit' do
    context 'when current user is owner of the deed' do
      before(:each) { get :edit, id: deed.id }

      it_should_behave_like 'deed setter'
      it_should_behave_like 'successful response'
      it_should_behave_like 'validating authorization'
    end

    context 'when current user is not owner of the deed' do
      before(:each) { session[:user_id] = another_user.id }

      it 'raises unauthorized exception' do
        expect { get :edit, id: deed.id }.to raise_exception(ApplicationController::UnauthorizedException)
      end
    end
  end

  describe 'patch update' do
    context 'when current user is owner of the deed' do
      before(:each) { patch :update, id: deed.id, deed: { name: 'My other deed' } }

      it 'redirects to deed page' do
        expect(response).to redirect_to(deed)
      end

      it_should_behave_like 'deed setter'
    end

    context 'when current user is not owner of the deed' do
      before(:each) { session[:user_id] = another_user.id }

      it 'raises unauthorized exception' do
        expect { patch :update, id: deed.id }.to raise_exception(ApplicationController::UnauthorizedException)
      end
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: deed.id } }
    context 'when current user is owner of the deed' do
      it 'redirects to deeds page' do
        action.call
        expect(response).to redirect_to(my_deeds_path)
      end

      it 'deletes deed from database' do
        expect(action).to change(Deed, :count).by(-1)
      end
    end

    context 'when current user is not owner of the deed' do
      before(:each) { session[:user_id] = another_user.id }

      it 'raises unauthorized exception' do
        expect { delete :destroy, id: deed.id }.to raise_exception(ApplicationController::UnauthorizedException)
      end
    end
  end
end
