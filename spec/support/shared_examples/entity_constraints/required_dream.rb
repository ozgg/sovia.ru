require 'rails_helper'

RSpec.shared_examples_for 'required_dream' do
  describe 'validation' do
    it 'fails without dream' do
      subject.dream = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:dream)
    end
  end
end
