require 'rails_helper'

RSpec.shared_examples_for 'commentable_by_community' do
  describe '#commentable_by?' do
    context 'when it is not deleted' do
      it 'returns true for user' do
        expect(subject).to be_commentable_by(User.new)
      end

      it 'returns false for nil' do
        expect(subject).not_to be_commentable_by(nil)
      end
    end

    context 'when it is deleted' do
      before(:each) { subject.deleted = true }

      it 'returns false for user' do
        expect(subject).not_to be_commentable_by(User.new)
      end

      it 'returns false for owner' do
        expect(subject).not_to be_commentable_by(subject.user)
      end
    end
  end
end
