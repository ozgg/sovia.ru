require 'rails_helper'

RSpec.describe Admin::CodesController, type: :controller do
  let!(:entity) { create :code }
  let(:required_roles) { :administrator }

  before :each do
    allow(subject).to receive(:require_role)
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  it_behaves_like 'list_for_administration'
  it_behaves_like 'show_entity_with_required_roles'
end
