require 'rails_helper'

RSpec.describe Admin::QuestionsController, type: :controller do
  let!(:entity) { create :question }

  before :each do
    allow(subject).to receive(:require_role)
    allow(entity.class).to receive(:find).and_call_original
  end

  it_behaves_like 'list_for_interpreters'
  it_behaves_like 'deletable_entity_for_interpreters'

  describe 'get comments' do
    before :each do
      allow(Comment).to receive(:page_for_administration).and_call_original
      expect_any_instance_of(entity.class).to receive(:comments).and_call_original
      get :comments, params: { id: entity }
    end

    it_behaves_like 'page_for_interpreters'
    it_behaves_like 'entity_finder'
    it_behaves_like 'http_success'

    it 'prepares list of entity comments' do
      expect(Comment).to have_received(:page_for_administration)
    end
  end
end