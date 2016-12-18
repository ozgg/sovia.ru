require 'rails_helper'

RSpec.describe Admin::WordsController, type: :controller do
  let!(:entity) { create :word }
  let(:required_roles) { [:chief_interpreter, :interpreter] }

  it_behaves_like 'index_entities_with_required_roles'
  it_behaves_like 'show_entity_with_required_roles'

  describe 'get dreams' do
    before :each do
      allow(subject).to receive(:require_role)
      allow(entity.class).to receive(:find_by).and_return(entity)
      expect(entity).to receive(:dreams).and_call_original
      allow(Dream).to receive(:page_for_administration)
      get :dreams, params: { id: entity.id }
    end

    it_behaves_like 'required_roles'
    it_behaves_like 'entity_finder'
    it_behaves_like 'http_success'

    it 'sends :page_for_administration to Dream' do
      expect(Dream).to have_received(:page_for_administration)
    end
  end
end
