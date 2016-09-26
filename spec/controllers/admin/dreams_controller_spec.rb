require 'rails_helper'

RSpec.describe Admin::DreamsController, type: :controller do
  let!(:entity) { create :dream }

  it_behaves_like 'list_for_administration'
  it_behaves_like 'deletable_entity_for_administration'
end
