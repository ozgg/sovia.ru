require 'rails_helper'

RSpec.shared_examples_for 'list_for_owner' do
  describe 'get index' do
    before :each do
      allow(subject).to receive(:restrict_anonymous_access)
      allow(subject).to receive(:current_user).and_return(user)
      allow(entity.class).to receive(:page_for_owner)
      get :index
    end

    it_behaves_like 'page_for_user'

    it 'calls ::page_for_owner on entity class' do
      expect(entity.class).to have_received(:page_for_owner)
    end
  end
end
