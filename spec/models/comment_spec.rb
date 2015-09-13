require 'rails_helper'

RSpec.describe Comment, type: :model do
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
    let(:owner) { create :confirmed_user }
    let!(:dream) { create :dream, user: owner }

    context 'when entry owner is nil' do
      let!(:comment) { create :comment, commentable: create(:dream) }

      it 'returns false' do
        expect(comment).not_to be_notify_entry_owner
      end
    end

    context 'when entry owner is the same as comment owner' do
      let!(:comment) { create :comment, commentable: dream, user: owner }

      it 'returns false' do
        expect(comment).not_to be_notify_entry_owner
      end
    end

    context 'when entry owner is other user' do
      let!(:comment) { create :comment, commentable: dream }

      it 'checks if entry owner can receive letters' do
        expect(owner).to receive(:can_receive_letters?)
        comment.notify_entry_owner?
      end

      it 'returns true if entry owner can receive letters' do
        expect(owner).to receive(:can_receive_letters?).and_return(true)
        expect(comment).to be_notify_entry_owner
      end
    end

    context 'when entry owner is the same as parent comment owner' do
      let!(:parent_comment) { create :comment, commentable: dream, user: owner }
      let!(:comment) { create :comment, commentable: dream, parent: parent_comment }

      it 'returns false' do
        expect(comment).not_to be_notify_entry_owner
      end
    end
  end

  describe 'notify_parent_owner?' do
    let!(:owner) { create :confirmed_user }

    context 'when parent owner is anonymous' do
      let(:parent_comment) { create :comment }
      let(:comment) { create :comment, parent: parent_comment, commentable: parent_comment.commentable }

      it 'returns false' do
        expect(comment).not_to be_notify_parent_owner
      end
    end

    context 'when parent owner is the same as comment owner' do
      let(:parent_comment) { create :comment, user: owner }
      let(:comment) { create :comment, user: owner, parent: parent_comment, commentable: parent_comment.commentable }

      it 'returns false' do
        expect(comment).not_to be_notify_parent_owner
      end
    end

    context 'when parent owner is other user' do
      let(:parent_comment) { create :comment, user: owner }
      let(:comment) { create :comment, parent: parent_comment, commentable: parent_comment.commentable }

      it 'checks if parent owner can receive letters' do
        expect(owner).to receive(:can_receive_letters?)
        comment.notify_parent_owner?
      end

      it 'returns true if parent owner can receive letters' do
        allow(owner).to receive(:can_receive_letters?).and_return(true)
        expect(comment).to be_notify_parent_owner
      end
    end
  end
end
