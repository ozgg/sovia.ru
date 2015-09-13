require "rails_helper"

RSpec.describe CodeSender, type: :mailer do
  let!(:language) { create :russian_language }

  before :each do
    I18n.locale = language.code
  end

  describe 'email' do
    let!(:code) { create :confirmation_code }
    let(:mail) { CodeSender.email(code) }

    it 'has appropriate subject' do
      expect(mail.subject).to eq(I18n.t('code_sender.email.subject'))
    end

    it 'sends from support email' do
      expect(mail.from).to eq(['support@sovia.ru'])
    end

    it 'sends to code owner' do
      expect(mail.to).to eq([code.user.email])
    end

    it 'includes code in letter body' do
      expect(mail.body.encoded).to match(code.body)
    end
  end

  describe 'password' do
    let!(:code) { create :recovery_code }
    let(:mail) { CodeSender.password(code) }

    it 'has appropriate subject' do
      expect(mail.subject).to eq(I18n.t('code_sender.password.subject'))
    end

    it 'sends from support email' do
      expect(mail.from).to eq(['support@sovia.ru'])
    end

    it 'sends to code owner' do
      expect(mail.to).to eq([code.user.email])
    end

    it 'includes code in letter body' do
      expect(mail.body.encoded).to match(code.body)
    end
  end
end