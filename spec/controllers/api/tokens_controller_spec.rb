require 'rails_helper'

RSpec.describe Api::TokensController, type: :controller do
  let(:user) { create :administrator }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'post toggle' do
    let(:entity) { create :token }
    let(:action) { -> { post :toggle, params: { id: entity, parameter: :active } } }

    context 'when entity is editable by user' do
      before :each do
        allow_any_instance_of(entity.class).to receive(:editable_by?).and_return(true)
        action.call
      end

      it_behaves_like 'http_success'

      it 'toggles parameters' do
        entity.reload
        expect(entity).not_to be_active
      end
    end

    context 'when entity is not editable by user' do
      before :each do
        allow_any_instance_of(entity.class).to receive(:editable_by?).and_return(false)
      end

      it_behaves_like 'record_not_found_exception'
    end
  end
end
