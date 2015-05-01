require 'rails_helper'

RSpec.describe PlacesController, type: :controller, wip: true do
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
    context 'checking'
    pending
  end

  describe 'get edit' do
    pending
  end

  describe 'patch update' do
    pending
  end

  describe 'delete destroy' do
    pending
  end

  describe '#restrict_editing' do
    pending
  end

  describe '#restrict_visibility' do
    pending
  end
end
