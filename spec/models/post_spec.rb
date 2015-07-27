require 'rails_helper'

RSpec.describe Post, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'
  it_behaves_like 'has_trace'

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

  describe '#tags_string=' do
    let!(:post) { create :post }
    let!(:existing_tag) { create :tag, language: post.language }

    it 'adds new tags to post'
    it 'ignores empty tags'
    it 'ignores repeating tags'
    it 'removes absent tags'
  end

  describe '#cache_tags!' do
    it 'sets sorted tags to tags_cache'
  end
end
