require 'rails_helper'

RSpec.shared_examples_for 'commentable_by_community' do
  let(:model) { described_class.to_s.underscore.to_sym }

  describe '#commentable_by?' do
    let(:entity) { create model }

    it 'returns true for user' do
      expect(entity).to be_commentable_by(User.new)
    end

    it 'returns false for anonymous user' do
      expect(entity).not_to be_commentable_by(nil)
    end
  end
end
