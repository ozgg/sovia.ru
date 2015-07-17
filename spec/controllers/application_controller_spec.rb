require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#current_user' do
    let(:user) { create :user }

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
end
