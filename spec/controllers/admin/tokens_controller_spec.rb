require 'rails_helper'

RSpec.describe Admin::TokensController, type: :controller do
  let!(:entity) { create :token }

  it_behaves_like 'list_for_administration'
  it_behaves_like 'entity_for_administration'
end
