require 'rails_helper'

RSpec.describe Post, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'required_user'

  describe 'class definition' do
    it 'includes has_trace' do
      expect(Post.included_modules).to include(HasTrace)
    end

    it 'includes has_owner' do
      expect(Post.included_modules).to include(HasOwner)
    end
  end

  describe 'validateion' do
    it 'fails without title' do
      post = build :post, title: ' '
      expect(post).not_to be_valid
    end

    it 'fails without lead' do
      post = build :post, lead: ' '
      expect(post).not_to be_valid
    end

    it 'fails without body' do
      post = build :post, body: ' '
      expect(post).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :post).to be_valid
    end
  end
end
