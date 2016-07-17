require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  let(:user) { create :user, password: '1234', password_confirmation: '1234', network: :native }

  describe 'get new' do
    context 'when user is not logged in' do
      before :each do
        allow(subject).to receive(:current_user).and_return(nil)
        get :new
      end

      it_behaves_like 'successful_response'
    end

    context 'when user is logged in' do
      before :each do
        allow(subject).to receive(:current_user).and_return(user)
        get :new
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'post create' do
    context 'when user is logged in' do
      before :each do
        allow(subject).to receive(:current_user).and_return(user)
        post :create
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when credentials are invalid' do
      let(:action) { -> { post :create, params: { login: user.slug, password: 'incorrect' } } }

      before(:each) do
        allow(subject).to receive(:current_user).and_return(nil)
      end

      it 'responds with HTTP 401' do
        action.call
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not set token cookie' do
        action.call
        expect(response.cookies['token']).to be_nil
      end

      it 'does not change tokens table' do
        expect(action).not_to change(Token, :count)
      end
    end

    context 'when credentials are valid' do
      let(:action) { -> { post :create, params: { login: user.screen_name, password: '1234' } } }

      before(:each) do
        allow(subject).to receive(:current_user).and_return(nil)
      end

      it 'adds token to table' do
        expect(action).to change(Token, :count).by(1)
      end

      it 'sets token cookie for user' do
        action.call
        token = Token.last
        expect(response.cookies['token']).to eq("#{user.id}:#{token.token}")
      end

      it 'redirects to root path' do
        action.call
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not allowed to log in' do
      let(:user) { create :user, password: '1', password_confirmation: '1', network: 0, allow_login: false }
      let(:action) { -> { post :create, params: { login: user.slug, password: '1' } } }

      before(:each) do
        request.cookies['token'] = nil
        allow(subject).to receive(:current_user).and_return(nil)
      end

      it 'responds with HTTP 401' do
        action.call
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create token' do
        expect(action).not_to change(Token, :count)
      end

      it 'does not set token cookie' do
        action.call
        expect(response.cookies['token']).to be_nil
      end
    end
  end

  describe 'delete destroy' do
    let!(:token) { create :token, user: user }

    before :each do
      request.cookies['token'] = token.cookie_pair
      allow(subject).to receive(:current_user).and_return(user)
      delete :destroy
    end

    it 'deactivates token' do
      token.reload
      expect(token).not_to be_active
    end

    it 'clears token cookie' do
      expect(response.cookies['token']).to be_nil
    end

    it 'redirects to root path' do
      expect(response).to redirect_to(root_path)
    end
  end
end
