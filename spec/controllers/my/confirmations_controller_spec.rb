require 'rails_helper'

RSpec.describe My::ConfirmationsController, type: :controller do
  describe 'get show' do
    it 'renders view "show"'
  end

  describe 'post create' do
    context 'when email is confirmed' do
      it 'redirects to my_confirmation_path'
      it 'does not request code'
    end

    context 'when email is not set' do
      it 'redirects to my_profile_path'
      it 'does not request code'
    end

    context 'when email is not confirmed' do
      it 'requests new code'
      it 'sends code to user'
      it 'redirects to my_confirmation_path'
    end
  end

  describe 'patch update' do
    context 'when code is valid' do
      it 'sets email_confirmed to true'
      it 'sets code.active to true'
      it 'redirects to root path'
    end

    context 'when code is invalid' do
      it 'redirects to my_confirmation_path'
    end
  end
end
