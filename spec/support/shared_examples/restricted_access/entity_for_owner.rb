require 'rails_helper'

RSpec.shared_examples_for 'entity_for_owner' do
  describe 'get show' do
    let(:action) { -> { get :show, params: { id: entity } } }

    before :each do
      allow(entity.class).to receive(:find).and_call_original
    end

    context 'when place is owned by user' do
      before :each do
        allow_any_instance_of(entity.class).to receive(:owned_by?).and_return(true)
        action.call
      end

      it_behaves_like 'entity_finder'
      it_behaves_like 'http_success'
    end

    context 'when entity is not owned by user' do
      before :each do
        allow_any_instance_of(entity.class).to receive(:owned_by?).and_return(false)
      end

      it_behaves_like 'record_not_found_exception'
    end
  end
end
