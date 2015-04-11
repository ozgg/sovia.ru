require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'validation' do
    it 'fails without body' do
      answer = build :answer, body: ' '
      expect(answer).not_to be_valid
    end

    it 'passes with valid data' do
      expect(build :answer).to be_valid
    end
  end
end
