require 'rails_helper'

RSpec.describe Pattern, type: :model do
  it_behaves_like 'has_name_with_slug'
  it_behaves_like 'finds_by_name'
  it_behaves_like 'has_unique_slug'
  it_behaves_like 'has_owner'

  describe 'validation' do
    it 'passes with valid attributes' do
      expect(build :pattern).to be_valid
    end
  end

  describe 'links=' do
    let!(:pattern) { create :pattern }

    it 'sets links for new patterns' do
      links  = { PatternLink.categories.keys.first => 'foo, bar,,,foo,bar ,,,' }
      action = -> { pattern.links = links }
      expect(action).to change(PatternLink, :count).by(2)
    end

    it 'removes links for empty list' do
      create :pattern_link, pattern: pattern
      action = -> { pattern.links = {} }
      expect(action).to change(PatternLink, :count).by(-1)
    end

    it 'removes links for absent targets' do
      create :pattern_link, pattern: pattern, target: create(:pattern, name: 'foo')
      create :pattern_link, pattern: pattern, target: create(:pattern, name: 'bar')
      action = -> { pattern.links = { PatternLink.categories.keys.first => 'foo' } }
      expect(action).to change(PatternLink, :count).by(-1)
    end

    it 'changes nothing for the same set' do
      link   = create :pattern_link, pattern: pattern
      action = -> { pattern.links = { link.category => link.target.name } }
      expect(action).not_to change(PatternLink, :count)
    end
  end

  describe 'links' do
    let!(:pattern) { create :pattern }

    it 'returns list of target patterns for each category' do
      target = create :pattern
      link   = create :pattern_link, pattern: pattern, target: target
      expect(pattern.links[link.category]).to eq([target])
    end

    it 'returns empty array for category without targets' do
      expect(pattern.links[PatternLink.categories.keys.first]).to eq([])
    end
  end
end
