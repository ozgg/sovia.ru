require 'rails_helper'

RSpec.describe ViolationsController, type: :controller do
  let(:user) { create :administrator }
  let!(:violation) { create :violation }

  before :each do
    allow(controller).to receive(:require_role)
    allow(controller).to receive(:current_user).and_return(user)
  end

  shared_examples 'entity_assigner' do
    it 'assigns violation to @entity' do
      expect(assigns[:entity]).to eq(violation)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'administrative_page'

    it 'assigns list of violations to @collection' do
      expect(assigns[:collection]).to include(violation)
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: violation }

    it_behaves_like 'administrative_page'
    it_behaves_like 'entity_assigner'

    it 'renders view "show"' do
      expect(response).to render_template(:show)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: violation } }

    context 'authorization' do
      before(:each) { action.call }

      it_behaves_like 'administrative_page'

      it 'redirects to violations page' do
        expect(response).to redirect_to(violations_path)
      end
    end

    it 'removes violation from database' do
      expect(action).to change(Violation, :count).by(-1)
    end
  end
end
