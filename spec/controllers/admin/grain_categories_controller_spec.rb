require 'rails_helper'

RSpec.describe Admin::GrainCategoriesController, type: :controller do
  let!(:entity) { create :grain_category }

  it_behaves_like 'list_for_administration'
  it_behaves_like 'entity_for_administration'
end
