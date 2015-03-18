require 'rails_helper'

RSpec.describe My::ConfirmationsController, type: :controller, wip: true do
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
    pending
  end

  describe '#redirect_without_email' do
    pending
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
end
