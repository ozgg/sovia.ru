require 'rails_helper'

RSpec.shared_examples_for 'deletable_entity_for_interpreters' do
  describe 'get show' do
    let(:user) { create :chief_interpreter }
    let(:action) { -> { get :show, params: { id: entity } } }

    before :each do
      allow(subject).to receive(:require_role)
      allow(entity.class).to receive(:find).and_call_original
    end

    it_behaves_like 'not_found_deleted_entity'

    context 'when entity is not deleted' do
      before :each do
        action.call
      end

      it_behaves_like 'page_for_interpreters'
      it_behaves_like 'entity_finder'
    end
  end
end
