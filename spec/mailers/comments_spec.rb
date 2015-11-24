require "rails_helper"

RSpec.describe Comments, type: :mailer do
  let!(:dream) { create :owned_dream, user: create(:confirmed_user) }
  let!(:parent_comment) { create :comment, commentable: dream, user: create(:confirmed_user) }
  let(:comment) { create :comment, parent: parent_comment, commentable: dream }

  describe 'entry_reply' do
    let(:mail) { Comments.entry_reply(comment) }

    it 'has appropriate subject' do
      expect(mail.subject).to eq(I18n.t('comments.entry_reply.subject'))
    end

    it 'sends from support email' do
      expect(mail.from).to eq(['support@sovia.ru'])
    end

    it 'sends to dream owner' do
      expect(mail.to).to eq([dream.user.email])
    end

    it 'includes link to comment in letter body' do
      expect(mail.body.encoded).to match(url_for(comment.commentable))
    end
  end

  describe 'comment_reply' do
    let(:mail) { Comments.comment_reply(comment) }

    it 'has appropriate subject' do
      expect(mail.subject).to eq(I18n.t('comments.comment_reply.subject'))
    end

    it 'sends from support email' do
      expect(mail.from).to eq(['support@sovia.ru'])
    end

    it 'sends to parent comment owner' do
      expect(mail.to).to eq([parent_comment.user.email])
    end

    it 'includes link to comment in letter body' do
      expect(mail.body.encoded).to match(url_for(comment.commentable))
    end
  end
end
