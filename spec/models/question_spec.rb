require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'has_owner'
  it_behaves_like 'has_trace'
  it_behaves_like 'commentable_by_community'

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
