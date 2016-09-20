require 'rails_helper'

RSpec.shared_examples_for 'not_found_deleted_entity' do
  context 'when entity is deleted' do
    before :each do
      entity.update! deleted: true
    end

    it_behaves_like 'record_not_found_exception'
  end
end
