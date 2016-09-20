require 'rails_helper'

RSpec.describe My::ConfirmationsController, type: :controller do
  describe 'get show' do
    before(:each) { get :show }

    it_behaves_like 'http_success'
  end

  describe 'post create' do
    context 'when email is confirmed' do
      let(:user) { create :confirmed_user }

      before :each do
        allow(controller).to receive(:current_user).and_return(user)
        allow(Code).to receive(:confirmation_for_user)
        post :create
      end

      it 'redirects to my_confirmation_path' do
        expect(response).to redirect_to(my_confirmation_path)
      end

      it 'does not request code' do
        expect(Code).not_to have_received(:confirmation_for_user)
      end
    end

    context 'when email is not set' do
      let(:user) { create :user }

      before :each do
        allow(controller).to receive(:current_user).and_return(user)
        allow(Code).to receive(:confirmation_for_user)
        post :create
      end

      it 'redirects to edit_my_profile_path' do
        expect(response).to redirect_to(edit_my_profile_path)
      end

      it 'does not request code' do
        expect(Code).not_to have_received(:confirmation_for_user)
      end
    end

    context 'when email is not confirmed' do
      let(:user) { create :unconfirmed_user }
      let(:action) { -> { post :create } }

      before :each do
        allow(controller).to receive(:current_user).and_return(user)
        allow(Code).to receive(:confirmation_for_user).and_return(create :confirmation_code, user: user)
      end

      it 'requests new code' do
        action.call
        expect(Code).to have_received(:confirmation_for_user)
      end

      it 'sends code to user' do
        expect(action).to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'redirects to my_confirmation_path' do
        action.call
        expect(response).to redirect_to(my_confirmation_path)
      end
    end

    it 'restricts anonymous access' do
      allow(controller).to receive(:current_user).and_return(create :confirmed_user)
      expect(controller).to receive(:restrict_anonymous_access)
      post :create
    end
  end

  describe 'patch update' do
    let(:user) { create :unconfirmed_user }

    before :each do
      allow(controller).to receive(:current_user).and_return(user)
    end

    context 'when code is valid' do
      let(:code) { create :confirmation_code, user: user, payload: user.email }

      before(:each) { patch :update, params: { code: code.body } }

      it 'sets email_confirmed to true' do
        user.reload
        expect(user).to be_email_confirmed
      end

      it 'sets code.active to true' do
        code.reload
        expect(code).to be_activated
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when code is invalid' do
      before(:each) { patch :update, params: { code: 'invalid' } }

      it 'redirects to my_confirmation_path' do
        expect(response).to redirect_to(my_confirmation_path)
      end

      it 'does not set email_confirmed to true' do
        user.reload
        expect(user).not_to be_email_confirmed
      end
    end

    it 'restricts anonymous access' do
      expect(controller).to receive(:restrict_anonymous_access)
      patch :update
    end
  end
end
