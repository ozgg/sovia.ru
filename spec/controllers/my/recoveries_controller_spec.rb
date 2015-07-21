require 'rails_helper'

RSpec.describe My::RecoveriesController, type: :controller, wip: true do
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

  describe 'patch update' do
    context 'when code is invalid' do
      it 'does not change user'
      it 'redirects to my_recovery_path'
    end

    context 'when login is invalid' do
      it 'does not change code'
      it 'redirects to my_recovery_path'
    end

    context 'when code is expired' do
      it 'does not change user'
      it 'does not change code'
      it 'redirects to my_recovery_path'
    end

    context 'when form is invalid' do
      it 'does not change user'
      it 'does not change code'
      it 'redirects to my_recovery_path'
    end

    context 'when everything is valid' do
      it 'updates password for user'
      it 'sets email_confirmed to true'
      it 'deactivates code'
      it 'creates new token'
      it 'sets token cookie'
      it 'redirects to root_path'
    end
  end
end
