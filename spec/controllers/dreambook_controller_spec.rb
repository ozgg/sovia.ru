require 'rails_helper'

RSpec.describe DreambookController, type: :controller do
  let!(:pattern_a) { create :pattern, name: 'первый' }
  let!(:pattern_b) { create :pattern, name: 'второй' }

  shared_examples 'setting_letters' do
    it 'assigns letters to @letters' do
      expect(assigns[:letters]).to be_an(Array)
    end

    it 'includes letter Ы in @letters' do
      expect(assigns[:letters]).to include('Ы')
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'setting_letters'
  end

  describe 'get search' do
    it 'assigns found patterns to @patterns' do
      get :search, query: 'ер'
      expect(assigns[:patterns]).to include(pattern_a)
    end

    it 'assigns nothing to @patterns for empty query' do
      get :search
      expect(assigns[:patterns]).to be_blank
    end

    it 'does not assign mismatching pattern to @patterns' do
      get :search, query: 'ер'
      expect(assigns[:patterns]).not_to include(pattern_b)
    end
  end

  describe 'get letter' do
    before(:each) { get :letter, letter: pattern_a.name[0] }

    it_behaves_like 'setting_letters'

    it 'includes matching pattern to @patterns' do
      expect(assigns[:patterns]).to include(pattern_a)
    end

    it 'does not include mismatching pattern to @patterns' do
      expect(assigns[:patterns]).not_to include(pattern_b)
    end
  end

  describe 'get word' do
    before(:each) { get :word, letter: pattern_a.name[0], word: pattern_a.name }

    it_behaves_like 'setting_letters'

    it 'assigns pattern to @pattern' do
      expect(assigns[:pattern]).to eq(pattern_a)
    end
  end
end
