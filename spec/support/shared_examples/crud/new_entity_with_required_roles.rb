require 'rails_helper'

RSpec.shared_examples_for 'new_entity_with_required_roles' do
  describe 'get new' do
    before :each do
      get :new
    end

    it_behaves_like 'required_roles'
    it_behaves_like 'http_success'
  end
end
