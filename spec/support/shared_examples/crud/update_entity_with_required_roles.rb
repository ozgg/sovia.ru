require 'rails_helper'

RSpec.shared_examples_for 'update_entity_with_required_roles' do
  describe 'patch update' do
    context 'when parameters are valid' do
      before :each do
        patch :update, params: valid_update_params
      end

      it_behaves_like 'required_roles'
      it_behaves_like 'entity_finder'

      it 'redirects to entity' do
        expect(response).to redirect_to(path_after_update)
      end
    end

    context 'when parameters are invalid' do
      before :each do
        patch :update, params: invalid_update_params
      end

      it_behaves_like 'required_roles'
      it_behaves_like 'entity_finder'
      it_behaves_like 'http_bad_request'
    end
  end
end
