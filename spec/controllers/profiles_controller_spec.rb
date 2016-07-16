require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  before :each do
    allow(User).to receive(:with_long_slug).and_return(entity)
  end

  describe 'get show' do
    let(:action) { -> { get :show, slug: entity.long_slug } }

    context 'when user is not deleted' do
      let!(:entity) { create :user }

      before(:each) { action.call }

      it_behaves_like 'entity_assigner'
      it_behaves_like 'successful_response'

      it 'finds user by long slug' do
        expect(User).to have_received(:with_long_slug).with(entity.long_slug)
      end

      it 'renders template "show"' do
        expect(response).to render_template(:show)
      end
    end

    context 'when user is deleted' do
      let!(:entity) { create :user, deleted: true }

      it 'responds with status 404' do
        expect(action).to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
