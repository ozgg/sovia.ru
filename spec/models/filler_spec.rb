require 'rails_helper'

RSpec.describe Filler, type: :model do
  context 'validation' do
    it 'fails without language' do
      filler = build :filler, language: nil
      expect(filler).not_to be_valid
    end

    it 'fails without body' do
      filler = build :filler, body: ' '
      expect(filler).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :filler).to be_valid
    end
  end
end
