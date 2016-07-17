require 'rails_helper'

RSpec.describe My::RecoveriesController, type: :controller do
  let(:user) { create :unconfirmed_user }

  before :each do
    expect(controller).to receive(:redirect_authenticated_user)
    allow(controller).to receive(:current_user).and_return(nil)
  end

  describe 'get show' do
    before(:each) { get :show }

    it_behaves_like 'successful_response'
  end

  describe 'post create' do
    context 'when user does not have email' do
      let(:user) { create :user }
      let(:action) { -> { post :create, params: { login: user.screen_name } } }

      it 'does not create new code' do
        expect(action).not_to change(Code, :count)
      end

      it 'redirects to my_recovery_path' do
        action.call
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'when user has email' do
      let(:code) { create :recovery_code, user: user }
      let(:action) { -> { post :create, params: { login: user.screen_name } } }

      before :each do
        allow(Code).to receive(:recovery_for_user).and_return(code)
      end

      it 'receives code for user' do
        expect(Code).to receive(:recovery_for_user).with(user)
        action.call
      end

      it 'sends code to user' do
        expect(action).to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'redirects to my_recovery_path' do
        action.call
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'when user enters non-existent login' do
      let(:action) { -> { post :create, params: { login: 'non_existent' } } }

      it 'does not create new code' do
        expect(action).not_to change(Code, :count)
      end

      it 'redirects to my_recovery_path' do
        action.call
        expect(response).to redirect_to(my_recovery_path)
      end
    end
  end

  describe 'patch update' do
    let(:new_password) { { user: { password: 'new' } } }
    let(:code) { create :recovery_code, user: user, payload: user.email }

    context 'when code is invalid' do
      before :each do
        patch :update, params: { login: user.screen_name, code: 'nope' }.merge(new_password)
      end

      it 'does not change user' do
        user.reload
        expect(user.authenticate 'new').to be_falsey
      end

      it 'redirects to my_recovery_path' do
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'when login is invalid' do
      let(:code) { create :recovery_code }

      before :each do
        patch :update, params: { login: user.screen_name, code: code.body }.merge(new_password)
      end

      it 'does not change code' do
        code.reload
        expect(code).not_to be_activated
      end

      it 'redirects to my_recovery_path' do
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'when code is expired' do
      let(:code) { create :recovery_code, user: user, quantity: 0 }

      before :each do
        patch :update, params: { login: user.screen_name, code: code.body }.merge(new_password)
      end

      it 'does not change user' do
        user.reload
        expect(user.authenticate 'new').to be_falsey
      end

      it 'redirects to my_recovery_path' do
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'when form is invalid' do
      before :each do
        patch :update, params: { login: user.slug, code: code.body, user: { password: ' ' } }
      end

      it 'does not change user' do
        user.reload
        expect(user.authenticate(' ')).to be_falsey
      end

      it 'does not change code' do
        code.reload
        expect(code).not_to be_activated
      end

      it 'responds with HTTP 400' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when everything is valid' do
      let(:action) { -> { patch :update, params: { login: user.screen_name, code: code.body }.merge(new_password) } }

      it 'updates password for user' do
        action.call
        user.reload
        expect(user.authenticate 'new').to be_truthy
      end

      it 'sets email_confirmed to true for the same email' do
        action.call
        user.reload
        expect(user).to be_email_confirmed
      end

      it 'sets activated flag in code to true' do
        action.call
        code.reload
        expect(code).to be_activated
      end

      it 'creates new token' do
        expect(action).to change(Token, :count).by(1)
      end

      it 'sets token cookie' do
        action.call
        expect(response.cookies['token']).to eq(Token.last.cookie_pair)
      end

      it 'redirects to root_path' do
        action.call
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
