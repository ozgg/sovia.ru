require 'rails_helper'

RSpec.describe Admin::BrowsersController, type: :controller do
  let!(:entity) { create :browser }
  let(:required_roles) { :administrator }

  before :each do
    allow(subject).to receive(:require_role)
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  it_behaves_like 'list_for_administration'
  it_behaves_like 'show_entity_with_required_roles'

  describe 'get agents' do
    before :each do
      allow(subject).to receive(:require_role)
      allow(entity.class).to receive(:find).and_call_original
      allow(Agent).to receive(:page_for_administration)
      get :agents, params: { id: entity.id }
    end

    it_behaves_like 'required_roles'
    it_behaves_like 'entity_finder'

    it 'gets administrative page of agents' do
      expect(Agent).to have_received(:page_for_administration)
    end
  end
end
