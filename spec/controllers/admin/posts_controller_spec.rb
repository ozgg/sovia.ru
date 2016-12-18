require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do
  let!(:entity) { create :post }
  let(:required_roles) { [:chief_editor, :editor] }

  it_behaves_like 'index_entities_with_required_roles'
  it_behaves_like 'show_entity_with_required_roles'

  describe 'get comments' do
    before :each do
      allow(subject).to receive(:require_role)
      allow(entity.class).to receive(:find_by).and_return(entity)
      expect(entity).to receive(:comments).and_call_original
      allow(Comment).to receive(:page_for_administration)
      get :comments, params: { id: entity.id }
    end

    it_behaves_like 'required_roles'
    it_behaves_like 'entity_finder'
    it_behaves_like 'http_success'

    it 'prepares list of entity comments' do
      expect(Comment).to have_received(:page_for_administration)
    end
  end
end
