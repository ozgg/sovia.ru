require 'rails_helper'

RSpec.shared_examples_for 'entity_for_administration' do
  describe 'get show' do
    before :each do
      allow(subject).to receive(:require_role)
      allow(entity.class).to receive(:find_by).and_return(entity)
      get :show, params: { id: entity.id }
    end

    it_behaves_like 'required_roles'
    it_behaves_like 'http_success'
    it_behaves_like 'entity_finder'
  end
end
