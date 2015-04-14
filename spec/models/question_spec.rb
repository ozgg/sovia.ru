require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'validating' do
    it 'fails without owner' do
      question = build :question, owner: nil
      expect(question).not_to be_valid
    end

    it 'fails without language' do
      question = build :question, language: nil
      expect(question).not_to be_valid
    end

    it 'fails without body' do
      question = build :question, body: ' '
      expect(question).not_to be_valid
    end

    it 'fails with too long body' do
      question = build :question, body: 'A' * 501
      expect(question).not_to be_valid
    end

    it 'passes with valid parameters' do
      expect(build :question).to be_valid
    end
  end
end
