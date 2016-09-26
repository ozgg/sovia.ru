require 'rails_helper'

RSpec.describe DreamsController, type: :controller, focus: true do
  let(:user) { create :user }
  let!(:entity) { create :dream, user: user }

  describe 'get index' do
    pending
  end

  describe 'get new' do
    pending
  end

  describe 'post create' do
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
    let(:pattern) { create :pattern }

    before :each do
      allow(Pattern).to receive(:find_by!).and_return(pattern)
      allow(entity.class).to receive(:tagged).and_call_original
      allow(entity.class).to receive(:page_for_visitors)
      get :tagged, params: { tag_name: tag.name }
    end

    it 'finds tag' do
      expect(Pattern).to have_received(:find_by!)
    end

    it 'finds tagged posts' do
      expect(entity.class).to have_received(:tagged)
    end

    it 'prepares page for visitors' do
      expect(entity.class).to have_received(:page_for_visitors)
    end
  end

  describe 'get archive' do
    before :each do
      allow(subject).to receive(:collect_months)
      allow(entity.class).to receive(:archive).and_call_original
      allow(entity.class).to receive(:page_for_visitors)
      get :archive, params: parameters
    end

    shared_examples 'collecting_months' do
      it 'collects months' do
        expect(subject).to have_received(:collect_months)
      end
    end

    shared_examples 'no_archive' do
      it 'does not call :archive to entity class' do
        expect(entity.class).not_to have_received(:archive)
      end
    end

    context 'when no year and month is given' do
      let(:parameters) { Hash.new }

      it_behaves_like 'collecting_months'
      it_behaves_like 'no_archive'
    end

    context 'when only year is given' do
      let(:parameters) { { year: '2016' } }

      it_behaves_like 'collecting_months'
      it_behaves_like 'no_archive'
    end

    context 'when year and month are given' do
      let(:parameters) { { year: '2016', month: '07' } }

      it_behaves_like 'collecting_months'

      it 'sends :archive to entity class' do
        expect(entity.class).to have_received(:archive)
      end

      it 'prepares page for visitors' do
        expect(entity.class).to have_received(:page_for_visitors)
      end
    end
  end
end
