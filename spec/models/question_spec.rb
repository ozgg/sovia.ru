require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'has_language'

  describe 'class definition' do
    it 'includes has_owner' do
      expect(Question.included_modules).to include(HasOwner)
    end

    it 'includes has_trace' do
      expect(Question.included_modules).to include(HasTrace)
    end
  end

  describe 'validation' do
    it 'fails with question text shorter than 10 characters' do
      question = build :question, body: 'What?????'
      expect(question).not_to be_valid
    end

    it 'fails with question text longer than 500 characters' do
      question = build :question, body: 'A' * 501
      expect(question).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :question).to be_valid
    end
  end
end
