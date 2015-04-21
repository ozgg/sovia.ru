require 'rails_helper'

RSpec.describe Pattern, type: :model do
  describe 'validation' do
    it 'fails without language' do
      pattern = build :pattern, language: nil
      expect(pattern).not_to be_valid
    end

    it 'fails without name' do
      pattern = build :pattern, name: ' '
      expect(pattern).not_to be_valid
    end

    it 'generates code' do
      pattern = build :pattern, name: 'aaa'
      pattern.valid?
      expect(pattern.code).not_to be_nil
    end

    it 'fails for name without any letters or numbers' do
      pattern = build :pattern, name: '?!'
      expect(pattern).not_to be_valid
    end

    it 'passes for letter ё' do
      pattern = build :pattern, name: 'ё'
      expect(pattern).to be_valid
    end

    it 'passes for letter Ё' do
      pattern = build :pattern, name: 'Ё'
      expect(pattern).to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :pattern).to be_valid
    end
  end

  context '#prepare_code!' do
    it 'leaves only letters and numbers in code' do
      pattern = build :pattern, name: '?Ёжик in the Woods - 1.jpg'
      expect(pattern.prepare_code!).to eq('ёжикinthewoods1jpg')
    end
  end
end
