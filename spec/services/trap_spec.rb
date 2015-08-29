require 'rails_helper'

RSpec.describe Trap do
  describe '#suspect_spam?' do
    let(:user) { create :user }

    it 'returns true for anonymous user with links' do
      expect(Trap.suspect_spam? nil, 'https://example.com').to be
    end

    it 'returns false for anonymous user without links' do
      expect(Trap.suspect_spam? nil, 'Clean!').not_to be
    end

    it 'returns true for simple user with links' do
      expect(Trap.suspect_spam? user, 'http://example.com').to be
    end

    it 'returns false for simple user without links' do
      expect(Trap.suspect_spam? user, 'Clean').not_to be
    end

    it 'returns false for decent user with links' do
      allow(user).to receive(:decent?).and_return(true)
      expect(Trap.suspect_spam? user, 'http://example.com').not_to be
    end
  end
end
