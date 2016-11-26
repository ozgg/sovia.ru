require 'rails_helper'

RSpec.describe Api::DreamsController, type: :controller do
  let(:user) { create :administrator }
  let(:entity) { create :dream }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(entity.class).to receive(:find).and_return(entity)
  end

  describe 'post toggle' do
    let(:required_roles) { :administrator }

    before(:each) do
      post :toggle, params: { id: entity, parameter: :needs_interpretation }
    end

    it_behaves_like 'required_roles'
    it_behaves_like 'entity_finder'
    it_behaves_like 'http_success'

    it 'toggles parameters' do
      entity.reload
      expect(entity).to be_needs_interpretation
    end
  end

  describe 'get interpretation' do
    let(:action) { -> { get :interpretation, params: { id: entity.id } } }

    context 'when entity is visible to current user' do
      before :each do
        allow(entity).to receive(:interpretation)
        allow(entity).to receive(:visible_to?).and_return(true)
        action.call
      end

      it_behaves_like 'no_roles_required'
      it_behaves_like 'entity_finder'
      it_behaves_like 'http_success'

      it 'receives dream interpretation' do
        expect(entity).to have_received(:interpretation)
      end
    end

    context 'when entity is not visible to current user' do
      before :each do
        allow(entity).to receive(:visible_to?).and_return(false)
        action.call
      end

      it_behaves_like 'no_roles_required'
      it_behaves_like 'entity_finder'
      it_behaves_like 'http_not_found'
    end
  end
end
