require 'rails_helper'

RSpec.describe Grain, type: :model do
  describe 'validation' do
    it 'fails without user' do
      grain = build :grain, user: nil
      expect(grain).not_to be_valid
    end

    it 'fails without name' do
      grain = build :grain, name: ' '
      expect(grain).not_to be_valid
    end

    it 'generates code' do
      grain = build :grain, name: 'aaa'
      grain.valid?
      expect(grain.code).not_to be_nil
    end

    it 'fails for name without any letters or numbers' do
      grain = build :grain, name: '?!'
      expect(grain).not_to be_valid
    end

    it 'passes for letter ё' do
      grain = build :grain, name: 'ё'
      expect(grain).to be_valid
    end

    it 'passes for letter Ё' do
      grain = build :grain, name: 'Ё'
      expect(grain).to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :grain).to be_valid
    end
  end

  context '#prepare_code!' do
    it 'leaves only letters and numbers in code' do
      grain = build :grain, name: '?Ёжик in the Woods - 1.jpg'
      expect(grain.prepare_code!).to eq('ёжикinthewoods1jpg')
    end
  end
end
