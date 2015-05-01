require 'rails_helper'

RSpec.describe PlacesController, type: :controller do
  let(:owner) { create :unconfirmed_user }
  let(:user) { create :unconfirmed_user }
  let!(:place) { create :place, user: owner }

  before :each do
    allow(controller).to receive(:restrict_anonymous_access)
    allow(controller).to receive(:restrict_editing)
    allow(controller).to receive(:restrict_visibility)
  end

  shared_examples 'setter' do
    it 'assigns place to @entity' do
      expect(assigns[:entity]).to be_a(Place)
    end
  end

  shared_examples 'anonymous restriction' do
    it 'restricts anonymous access' do
      expect(controller).to have_received(:restrict_anonymous_access)
    end
  end

  shared_examples 'editing restriction' do
    it 'restricts editing' do
      expect(controller).to have_received(:restrict_editing)
    end
  end

  shared_examples 'visibility restriction' do
    it 'restricts visibility' do
      expect(controller).to have_received(:restrict_visibility)
    end
  end

  describe 'get index' do
    it 'does not restrict access' do
      get :index
      expect(controller).not_to have_received(:restrict_anonymous_access)
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it 'assigns new Place to @entity' do
      expect(assigns[:entity]).to be_a_new(Place)
    end

    it_should_behave_like 'anonymous restriction'
  end

  describe 'post create' do
    let(:action) { -> { post :create, place: { name: 'My place' } } }
    before(:each) { session[:user_id] = owner.id }

    context 'restricting' do
      before(:each) { action.call }

      it 'redirects to created Place' do
        expect(response).to redirect_to(Place.last)
      end

      it_should_behave_like 'anonymous restriction'
    end

    context 'changing database' do
      it 'adds new record to places' do
        expect(action).to change(Place, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before :each do
      session[:user_id] = owner.id
      get :show, id: place.id
    end

    it_should_behave_like 'setter'
    it_should_behave_like 'visibility restriction'
  end

  describe 'get edit' do
    before :each do
      session[:user_id] = owner.id
      get :edit, id: place.id
    end

    it_should_behave_like 'setter'
    it_should_behave_like 'editing restriction'
  end

  describe 'patch update' do
    before :each do
      session[:user_id] = owner.id
      patch :update, id: place.id, place: { name: 'New place' }
    end

    it 'updates place data' do
      place.reload
      expect(place.name).to eq('New place')
    end

    it_should_behave_like 'setter'
    it_should_behave_like 'editing restriction'
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: place.id } }
    before(:each) { session[:user_id] = owner.id }

    context 'validating' do
      before(:each) { action.call }

      it_should_behave_like 'setter'
      it_should_behave_like 'editing restriction'
    end

    context 'changing database' do
      it 'removes place from database' do
        expect(action).to change(Place, :count).by(-1)
      end
    end
  end

  describe '#restrict_editing' do
    before :each do
      allow(controller).to receive(:restrict_editing).and_call_original
      controller.instance_variable_set :@entity, place
      session[:user_id] = owner.id
    end

    it 'calls Place#editable_by?' do
      expect(place).to receive(:editable_by?).with(owner).and_call_original
      controller.send :restrict_editing
    end
  end

  describe '#restrict_visibility' do
    before :each do
      allow(controller).to receive(:restrict_visibility).and_call_original
      controller.instance_variable_set :@entity, place
      session[:user_id] = owner.id
    end

    it 'calls Place#visible_to?' do
      expect(place).to receive(:visible_to?).with(owner).and_call_original
      controller.send :restrict_visibility
    end
  end
end
