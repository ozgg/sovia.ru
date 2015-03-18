require 'rails_helper'

RSpec.describe My::RecoveriesController, type: :controller, wip: true do
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

    it 'tracks user agent' do
      expect(controller).to have_received(:track_agent)
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
    context 'when email is set' do
      it 'creates new code in database'
      it 'sets user ip in created code'
      it 'sets user agent in created code'
      it 'sends message with code to user'
      it 'redirects to recovery page'
    end

    context 'when email is not set' do
      before(:each) { post :create, email: 'not-found@example.com' }

      it 'renders recovery page' do
        expect(response).to render_template(:show)
      end

      it_should_behave_like 'successful response'
      it_should_behave_like 'validating and tracking'
    end
  end

  describe 'patch update' do
    context 'when code is valid' do
      pending
    end

    context 'when code is invalid' do
      pending
    end
  end
end
