require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let(:user) { create :administrator }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'post toggle' do
    let(:entity) { create :user }

    before :each do
      post :toggle, params: { id: entity, parameter: :bot }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'http_success'

    it 'toggles parameters' do
      entity.reload
      expect(entity).to be_bot
    end
  end
end
