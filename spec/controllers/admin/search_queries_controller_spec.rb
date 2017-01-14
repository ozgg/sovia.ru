require 'rails_helper'

RSpec.describe Admin::SearchQueriesController, type: :controller do
  let(:entity) { create :search_query }
  let(:required_roles) { [:administrator] }

  it_behaves_like 'index_entities_with_required_roles'
end
