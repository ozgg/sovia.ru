require 'rails_helper'

RSpec.describe Word, type: :model do
  subject { build :word }

  it_behaves_like 'has_valid_factory'

  describe 'before validation' do
    it 'downcases body' do
      subject.body = 'СЛОВО'
      subject.valid?
      expect(subject.body).to eq('слово')
    end
  end

  describe 'validation' do
    it 'fails without body' do
      subject.body = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end

    it 'fails with non-unique body' do
      create :word, body: subject.body
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end

    it 'fails with too long body' do
      subject.body = 'ы' * 51
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end
  end
end
