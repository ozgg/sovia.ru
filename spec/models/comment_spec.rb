require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'has_owner'
  it_behaves_like 'has_trace'

  describe 'validation' do
    it 'fails without commentable object' do
      comment = build :comment, commentable: nil
      expect(comment).not_to be_valid
    end

    it 'fails without body' do
      comment = build :comment, body: ' '
      expect(comment).not_to be_valid
    end

    it 'fails with invalid parent' do
      parent = create :comment
      expect(build :comment, parent_id: parent.id).not_to be_valid
    end

    it 'fails with invisible commentable object' do
      dream = create :personal_dream
      expect(build :comment, commentable: dream).not_to be_valid
    end

    it 'fails with non-commentable object' do
      question = create :question
      expect(build :comment, commentable: question).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :comment).to be_valid
    end
  end

  describe 'notify_entry_owner?' do
    pending
  end

  describe 'notify_parent_owner?' do
    pending
  end
end
