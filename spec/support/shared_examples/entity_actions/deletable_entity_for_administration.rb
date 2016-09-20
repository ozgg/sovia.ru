require 'rails_helper'

RSpec.shared_examples_for 'deletable_entity_for_administration' do
  describe 'get show' do
    let(:user) { create :administrator }
    let(:action) { -> { get :show, params: { id: entity } } }

    before :each do
      allow(subject).to receive(:require_role)
      allow(subject).to receive(:current_user).and_return(user)
      allow(entity.class).to receive(:find).and_call_original
    end

    it_behaves_like 'not_found_deleted_entity'

    context 'when entity is not deleted' do
      before :each do
        action.call
      end

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'entity_finder'
    end
  end
end
