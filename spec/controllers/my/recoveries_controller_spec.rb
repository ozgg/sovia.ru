require 'rails_helper'

RSpec.describe My::RecoveriesController, type: :controller do
  let(:user) { create :unconfirmed_user }

  before :each do
    expect(controller).to receive(:redirect_authenticated_user)
    allow(controller).to receive(:current_user).and_return(nil)
  end

  describe 'get show' do
    before(:each) { get :show }

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'post create' do
    context 'when user does not have email' do
      let(:user) { create :user }
      let(:action) { -> { post :create, login: user.screen_name } }

      it 'does not create new code' do
        expect(action).not_to change(Code, :count)
      end

      it 'redirects to my_recovery_path' do
        action.call
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'when user has email' do
      let(:code) { create :code, user: user, category: Code.categories[:recovery] }
      let(:action) { -> { post :create, login: user.screen_name } }

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
      let(:action) { -> { post :create, login: 'non_existent' } }

      it 'does not create new code' do
        expect(action).not_to change(Code, :count)
      end

      it 'redirects to my_recovery_path' do
        action.call
        expect(response).to redirect_to(my_recovery_path)
      end
    end
  end

  describe 'patch update', wip: true do
    let(:new_password) { { user: { password: 'new', password_confirmation: 'new' } } }
    let(:code) { create :code, user: user, category: Code.categories[:recovery] }

    context 'when code is invalid' do
      let(:action) { -> { patch :update, { login: user.screen_name, code: 'nope' }.merge(new_password) } }

      it 'does not change user' do
        expect(action).not_to change(user, :password_digest)
      end

      it 'redirects to my_recovery_path' do
        action.call
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'when login is invalid' do
      let(:code) { create :code, category: Code.categories[:recovery] }
      let(:action) { -> { patch :update, { login: user.screen_name, code: code.body }.merge(new_password) } }

      it 'does not change code' do
        expect(action).not_to change(code)
      end

      it 'redirects to my_recovery_path' do
        action.call
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'when code is expired' do
      let(:code) { create :code, user: user, category: Code.categories[:recovery], activated: true }
      let(:action) { -> { patch :update, { login: user.sreen_name, code: code.body }.merge(new_password) } }

      it 'does not change user' do
        expect(action).not_to change(user)
      end

      it 'does not change code' do
        expect(action).not_to change(code)
      end

      it 'redirects to my_recovery_path' do
        action.call
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'when form is invalid' do
      let(:action) { -> { patch :update, login: user.uid, code: code.body, user: { password: '1' } } }

      it 'does not change user' do
        expect(action).not_to change(user)
      end

      it 'does not change code' do
        expect(action).not_to change(code)
      end

      it 'redirects to my_recovery_path' do
        action.call
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'when everything is valid' do
      let(:action) { -> { patch :update, { login: user.sreen_name, code: code.body }.merge(new_password) } }

      it 'updates password for user' do
        expect(action).to change(user, :password_digest)
      end

      it 'sets email_confirmed to true' do
        action.call
        user.reload
        expect(user).to be_email_confirmed
      end

      it 'deactivates code' do
        expect(action).to change(code, :activated)
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
