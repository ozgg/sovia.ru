require "rails_helper"

RSpec.describe Comments, type: :mailer do
  describe 'entry_reply' do
    let!(:user) { create :confirmed_user }
    let!(:post) { create :post, user: user }
    let!(:entity) { create :comment, commentable: post }

    let(:mail) { Comments.entry_reply(entity) }

    it 'has appropriate subject' do
      expect(mail.subject).to eq(I18n.t('comments.entry_reply.subject'))
    end

    it 'sends from support email' do
      expect(mail.from).to eq(['support@sovia.ru'])
    end

    it 'sends to comment owner' do
      expect(mail.to).to eq([user.email])
    end

    it 'includes comment in letter body' do
      expect(mail.body.encoded).to match(entity.body)
    end
  end
end
