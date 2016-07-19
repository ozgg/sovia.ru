require 'rails_helper'

RSpec.shared_examples_for 'commentable_by_community' do
  describe '#commentable_by?' do
    it 'returns true for user' do
      expect(subject).to be_commentable_by(User.new)
    end

    it 'returns false for nil' do
      expect(subject).not_to be_commentable_by(nil)
    end
  end
end
