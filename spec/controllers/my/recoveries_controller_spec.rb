require 'rails_helper'

RSpec.describe My::RecoveriesController, type: :controller do
  before :each do
    allow(controller).to receive(:allow_unauthorized_only)
    allow(controller).to receive(:track_agent)
  end

  shared_examples 'successful response' do
    it 'returns HTTP success' do
      expect(response).to have_http_status(:success)
    end
  end

  shared_examples 'validating and tracking' do
    it 'calls :allow_unauthorized_only' do
      expect(controller).to have_received(:allow_unauthorized_only)
    end
  end

  describe '#allow_unauthorized_only' do
    before(:each) { allow(controller).to receive(:allow_unauthorized_only).and_call_original }

    context 'when user is logged in' do
      it 'redirects to root path' do
        expect(controller).to receive(:redirect_to).with(root_path)
        session[:user_id] = create(:user).id
        controller.send(:allow_unauthorized_only)
      end
    end

    context 'when user is not logged in' do
      it 'returns nil' do
        expect(controller.send(:allow_unauthorized_only)).to be_nil
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

    context 'when email is set' do
      let(:user) { create :unconfirmed_user }
      let(:parameters) { { email: user.email } }

      it 'calls #password_recovery for user' do
        expect_any_instance_of(User).to receive(:password_recovery)
        post :create, parameters
      end

      it 'tracks IP and UA for code' do
        expect_any_instance_of(Code::Recovery).to receive(:track!).with(ip, agent)
        post :create, parameters
      end

      it 'sends message with code to user' do
        expect(-> { post :create, parameters }).to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'redirects to recovery page' do
        post :create, parameters
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'when email is not set' do
      before(:each) { post :create, email: 'not-found@example.com' }

      it 'renders recovery page' do
        expect(response).to render_template(:show)
      end

      it_should_behave_like 'successful response'
    end

    context 'validating and tracking' do
      before(:each) { post :create }

      it_should_behave_like 'validating and tracking'
    end
  end

  describe 'patch update' do
    let(:code) { create :password_recovery }
    let(:parameters) { { code: code.body, user: { password: 'a', password_confirmation: 'a', login: 'nope' } } }

    context 'when code is valid' do
      it 'sets code as active' do
        patch :update, parameters
        code.reload
        expect(code).to be_activated
      end

      it 'updates password for user' do
        expect_any_instance_of(User).to receive(:update).with(password: 'a', password_confirmation: 'a')
        patch :update, parameters
      end

      it 'redirects to login page' do
        patch :update, parameters
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when code is invalid' do
      let(:code) { create :password_recovery }
      let(:parameters) { { code: 'invalid', user: { password: 'a', password_confirmation: 'a' } } }

      it 'leaves code intact' do
        expect(-> { patch :update, parameters} ).not_to change(code, :activated)
      end

      it 'leaves user intact' do
        expect_any_instance_of(User).not_to receive(:update)
        patch :update, parameters
      end

      it 'redirects to recovery page' do
        patch :update, parameters
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context 'tracking and validating' do
      before(:each) { patch :update }

      it_should_behave_like 'validating and tracking'
    end
  end
end
