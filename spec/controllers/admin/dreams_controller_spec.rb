require 'rails_helper'

RSpec.describe Admin::DreamsController, type: :controller do
  let!(:entity) { create :dream }
  let(:required_roles) { :administrator }

  before :each do
    allow(subject).to receive(:require_role)
  end

  it_behaves_like 'index_entities_with_required_roles'
  it_behaves_like 'show_entity_with_required_roles'
  it_behaves_like 'show_entity_with_visibility_check'
end
