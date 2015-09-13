require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:user) { create :user }

  describe '#current_user' do
    before(:each) do
      allow(Token).to receive(:user_by_token).and_return(user)
    end

    context 'when @current_user is not set' do
      before(:each) do
        controller.instance_variable_set(:@current_user, nil)
        controller.current_user
      end

      it 'calls Token#user_by_token' do
        expect(Token).to have_received(:user_by_token)
      end

      it 'assigns user to @current_user' do
        expect(assigns[:current_user]).to eq(user)
      end
    end

    context 'when @current_user is set' do
      before(:each) do
        controller.instance_variable_set(:@current_user, user)
      end

      it 'returns user' do
        expect(controller.current_user).to eq(user)
      end

      it 'does not call Token#user_by_token' do
        controller.current_user
        expect(Token).not_to have_received(:user_by_token)
      end
    end
  end

  describe '#restrict_anonymous_access' do
    context 'when user is logged in' do
      before :each do
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'does not call redirect_to' do
        expect(controller).not_to receive(:redirect_to)
        controller.send(:restrict_anonymous_access)
      end
    end

    context 'when user is not logged in' do
      before :each do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it 'redirects to login path' do
        expect(controller).to receive(:redirect_to).with(login_path, alert: I18n.t(:please_log_in))
        controller.send(:restrict_anonymous_access)
      end
    end
  end
end
