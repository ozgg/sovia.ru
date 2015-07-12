require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'has_language'

  describe 'class definition' do
    it 'includes has_owner' do
      expect(Comment.included_modules).to include(HasOwner)
    end
  end

  describe 'validation' do
    it 'fails without commentable object' do
      comment = build :comment, commentable: nil
      expect(comment).not_to be_valid
    end

    it 'fails without body' do
      comment = build :comment, body: ' '
      expect(comment).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :comment).to be_valid
    end
  end
end
