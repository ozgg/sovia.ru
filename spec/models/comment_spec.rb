require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { build :comment }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'

  describe 'validation' do
    it 'fails without commentable object' do
      subject.commentable = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:commentable)
    end

    it 'fails without body' do
      subject.body = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end

    it 'fails with non-commentable commentable object' do
      commentable = create :post
      allow(commentable).to receive(:commentable_by?).and_return false
      subject.commentable = commentable
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:commentable)
    end
  end

  describe '#notify_entry_owner?' do
    let(:owner) { create :confirmed_user }
    let!(:commentable) { create :post, user: owner }

    context 'when entry owner is nil' do
      before :each do
        subject.commentable = create(:post)
        allow(commentable).to receive(:user).and_return(nil)
      end

      it 'returns false' do
        expect(subject.notify_entry_owner?).not_to be
      end
    end

    context 'when entry owner is the same as comment owner' do
      before :each do
        subject.commentable = commentable
        subject.user = owner
      end

      it 'returns false' do
        expect(subject.notify_entry_owner?).not_to be
      end
    end

    context 'when entry owner is other user' do
      before :each do
        subject.commentable = commentable
      end

      it 'checks if entry owner can receive letters' do
        expect(owner).to receive(:can_receive_letters?)
        subject.notify_entry_owner?
      end

      it 'returns true if entry owner can receive letters' do
        expect(owner).to receive(:can_receive_letters?).and_return(true)
        expect(subject.notify_entry_owner?).to be
      end
    end
  end

  describe '#visible_to?' do
    let(:commentable) { create :post }
    let(:user) { create :user }
    let(:administrator) { create :administrator }

    before :each do
      subject.commentable = commentable
    end

    context 'when commentable is visible to current user' do
      before :each do
        allow(commentable).to receive(:visible_to?).and_return(true)
      end

      context 'when comment is not deleted' do
        it 'returns true for anonym' do
          expect(subject).to be_visible_to(nil)
        end

        it 'returns true for user' do
          expect(subject).to be_visible_to(user)
        end

        it 'returns true for administrator' do
          expect(subject).to be_visible_to(administrator)
        end
      end

      context 'when comment is deleted' do
        before :each do
          subject.deleted = true
        end

        it 'returns false for anonym' do
          expect(subject).not_to be_visible_to(nil)
        end

        it 'returns false for user' do
          expect(subject).not_to be_visible_to(user)
        end

        it 'returns true for administrator' do
          expect(subject).to be_visible_to(administrator)
        end
      end
    end

    context 'when commentable is not visible to current user' do
      before :each do
        allow(commentable).to receive(:visible_to?).and_return(false)
      end

      it 'returns false for anonym' do
        expect(subject).not_to be_visible_to(nil)
      end

      it 'returns false for user' do
        expect(subject).not_to be_visible_to(user)
      end

      it 'returns false for administrator' do
        expect(subject).not_to be_visible_to(administrator)
      end
    end
  end
end
