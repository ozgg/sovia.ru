require 'rails_helper'

RSpec.describe DreamsController, type: :controller, wip: true do
  let(:language) { create :russian_language }
  let(:owner) { create :user, language: language }
  let(:user) { create :user, language: language }
  let!(:generally_accessible_dream) { create :dream, language: language }
  let!(:dream_for_community) { create :dream_for_community, user: owner, language: language }
  let!(:dream_for_followees) { create :dream_for_followees, user: owner, language: language }
  let!(:personal_dream) { create :personal_dream, user: owner, language: language }

  before :each do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:restrict_editing)
    allow_any_instance_of(Dream).to receive(:visible_to?).and_return(true)
    I18n.locale = language.code
  end

  shared_examples 'generally_accessible_dreams' do
    it 'adds generally accessible dreams to @collection' do
      expect(assigns[:collection]).to include(generally_accessible_dream)
    end
  end

  shared_examples 'visible_dreams_for_community' do
    it 'adds dreams for community to @collection' do
      expect(assigns[:collection]).to include(dream_for_community)
    end
  end

  shared_examples 'hidden_personal_dreams' do
    it 'does not add personal dreams to @collection' do
      expect(assigns[:collection]).not_to include(personal_dream)
    end
  end

  shared_examples 'hidden_dreams_for_followees' do
    it 'does not add dreams for followees to @collection' do
      expect(assigns[:collection]).not_to include(dream_for_followees)
    end
  end
  
  shared_examples 'entity_assigner' do
    it 'assigns Dream to @entity' do
      expect(assigns[:entity]).to be_a(Dream)
    end

    it 'checks visibility of entity to user' do
      expect(assigns[:entity]).to have_received(:visible_to?).with(user)
    end
  end

  shared_examples 'setting_dream_patterns' do
    it 'sets dream grains' do
      expect_any_instance_of(Dream).to receive(:patterns_string=)
      action.call
    end

    it 'caches dream patterns' do
      expect_any_instance_of(Dream).to receive(:cache_patterns!)
      action.call
    end
  end

  shared_examples 'not_setting_dream_patterns' do
    it 'does not set new grains' do
      expect_any_instance_of(Dream).not_to receive(:patterns_string=)
      action.call
    end

    it 'does not cache patterns' do
      expect_any_instance_of(Dream).not_to receive(:cache_patterns!)
      action.call
    end
  end

  describe 'get index' do
    context 'when user is not logged in' do
      it 'does not add dreams for users to @collection'
    end
  end

  describe 'get new' do
    pending
  end

  describe 'post create' do
    pending
  end

  describe 'get show' do
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

  describe 'get tagged' do
    pending
  end
end
