require 'rails_helper'

RSpec.describe My::ConfirmationsController, type: :controller do
  let(:user) { create :unconfirmed_user }

  before :each do
    session[:user_id] = user.id
    allow(controller).to receive(:allow_authorized_only)
    allow(controller).to receive(:redirect_without_email)
    allow(controller).to receive(:redirect_confirmed_user)
    allow(controller).to receive(:track_agent)
  end

  shared_examples 'successful response' do
    it 'returns HTTP success' do
      expect(response).to have_http_status(:success)
    end
  end

  shared_examples 'validating and tracking' do
    it 'calls :allow_authorized_only' do
      expect(controller).to have_received(:allow_authorized_only)
    end

    it 'redirects users without email' do
      expect(controller).to have_received(:redirect_without_email)
    end

    it 'redirects already confirmed users' do
      expect(controller).to have_received(:redirect_confirmed_user)
    end

    it 'tracks user agent' do
      expect(controller).to have_received(:track_agent)
    end
  end

  describe '#redirect_confirmed_user' do
    before(:each) { allow(controller).to receive(:redirect_confirmed_user).and_call_original }

    context 'when user is confirmed' do
      it 'redirects to user profile path' do
        expect(controller).to receive(:redirect_to).with(my_profile_path)
        session[:user_id] = create(:confirmed_user).id
        controller.send(:redirect_confirmed_user)
      end
    end

    context 'when user is not confirmed' do
      it 'returns nil' do
        session[:user_id] = create(:unconfirmed_user).id
        expect(controller.send(:redirect_confirmed_user)).to be_nil
      end
    end
  end

  describe '#redirect_without_email' do
    before(:each) { allow(controller).to receive(:redirect_without_email).and_call_original }

    context 'when user has no email' do
      it 'redirects to user profile editing path' do
        expect(controller).to receive(:redirect_to).with(edit_my_profile_path)
        session[:user_id] = create(:user).id
        controller.send(:redirect_without_email)
      end
    end

    context 'when user has email' do
      it 'returns nil' do
        session[:user_id] = create(:unconfirmed_user).id
        expect(controller.send(:redirect_without_email)).to be_nil
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show }

    it_should_behave_like 'successful response'
    it_should_behave_like 'validating and tracking'
  end

  describe 'post create' do
    let(:ip) { '127.0.0.1' }
    let(:agent) { create :agent }

    before :each do
      allow(request).to receive(:remote_ip).and_return(ip)
      allow(controller).to receive(:agent).and_return(agent)
    end

    context 'delivering code' do
      it 'calls #email_confirmation for user' do
        expect_any_instance_of(User).to receive(:email_confirmation)
        post :create
      end

      it 'tracks IP and UA for code' do
        expect_any_instance_of(Code::Confirmation).to receive(:track!).with(ip, agent)
        post :create
      end

      it 'sends message with code to user' do
        expect(-> { post :create }).to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'redirects to confirmation page' do
        post :create
        expect(response).to redirect_to(my_confirmation_path)
      end
    end

    context 'validating and tracking' do
      before(:each) { post :create }

      it_should_behave_like 'validating and tracking'
    end
  end

  describe 'patch update' do
    let(:code) { create :email_confirmation }
    let(:parameters) { { code: code.body } }

    before(:each) { session[:user_id] = code.user_id }

    context 'when code is valid' do
      it 'sets code as active' do
        patch :update, parameters
        code.reload
        expect(code).to be_activated
      end

      it 'updates confirmation flag for user' do
        expect_any_instance_of(User).to receive(:update).with(mail_confirmed: true)
        patch :update, parameters
      end

      it 'redirects to profile page' do
        patch :update, parameters
        expect(response).to redirect_to(my_profile_path)
      end
    end

    context 'when code is invalid' do
      let(:code) { create :email_confirmation }
      let(:parameters) { { code: 'invalid' } }

      it 'leaves code intact' do
        expect(-> { patch :update, parameters }).not_to change(code, :activated)
      end

      it 'leaves user intact' do
        expect_any_instance_of(User).not_to receive(:update)
        patch :update, parameters
      end

      it 'redirects to confirmation page' do
        patch :update, parameters
        expect(response).to redirect_to(my_confirmation_path)
      end
    end

    context 'tracking and validating' do
      before(:each) { patch :update }

      it_should_behave_like 'validating and tracking'
    end
  end
end
